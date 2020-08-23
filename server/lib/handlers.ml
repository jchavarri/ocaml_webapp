open Core
open Tyxml
open Opium.Std

(** A <head> component shared by all pages *)
let default_head =
  let open Html in
  head
    (title (txt "OCaml Webapp Tutorial"))
    [
      meta ~a:[ a_charset "UTF-8" ] ();
      link ~rel:[ `Icon ]
        ~a:[ a_mime_type "image/x-icon" ]
        ~href:"/static/favicon.ico" ();
      link ~rel:[ `Stylesheet ] ~href:"/static/style.css" ();
    ]

(** The basic page layout, emitted as an [`Html string] which Opium can use as a
    response *)
let basic_page ?payload content =
  let raw_html =
    let open Html in
    let content_container =
      [
        div ~a:[ a_id "root" ] content;
        script ~a:[ a_src (Xml.uri_of_string "/static/Index.js") ] (txt "");
      ]
    in
    let body_children =
      match payload with
      | Some p -> p :: content_container
      | None -> content_container
    in
    html default_head (body body_children) |> Format.asprintf "%a" (Html.pp ())
  in
  `Html raw_html

let page_with_payload payload elements =
  let open Html in
  basic_page
    ~payload:
      (script
         ~a:[ a_id Shared.Api.payload_id; a_mime_type "application/json" ]
         (Unsafe.data payload))
    elements

let json str = `Json (Ezjsonm.from_string str)

let respond_or_err resp = function
  | Ok v -> respond' @@ resp v
  | Error err ->
    respond'
    @@ basic_page
         Html.
           [ p [ txt (Printf.sprintf "Oh no! Something went wrong: %s" err) ] ]

let excerpt_of_form_data data =
  let find data key =
    let open Core in
    (* NOTE Should handle error in case of missing fields *)
    List.Assoc.find_exn ~equal:String.equal data key |> String.concat
  in
  let author = find data "author"
  and excerpt = find data "excerpt"
  and source = find data "source"
  and page =
    match find data "page" with
    | "" -> None
    | p -> Some p
  in
  Lwt.return Shared.Excerpt_t.{ author; excerpt; source; page }

(** The route handlers for our app *)
module Handlers = struct
  type request = Request.t

  type response = Response.t Lwt.t

  module Pages = struct
    (** Defines a handler that replies to requests at the root endpoint *)
    let root _req = respond' @@ basic_page (Shared.PageWelcome.make ())

    (** Defines a handler that takes a path parameter from the route *)
    let hello lang _req = respond' @@ basic_page (Shared.PageHello.make ~lang)

    (** Fallback handler in case the endpoint is called without a language parameter *)
    let hello_fallback _req =
      respond' @@ basic_page (Shared.PageHelloFallback.make ())

    let excerpts_add _req =
      respond' @@ basic_page (Shared.PageAddExcerpt.make ())

    let excerpts_by_author name req =
      let open Lwt in
      Db.Get.excerpts_by_author name req
      >>= respond_or_err @@ fun excerpts ->
          page_with_payload
            (Shared.PageExcerpts_j.string_of_payload excerpts)
            (Shared.PageExcerpts.make ~excerpts)

    let authors_with_excerpts req =
      let open Lwt in
      Db.Get.authors req
      >>= respond_or_err @@ fun authors ->
          page_with_payload
            (Shared.PageAuthorExcerpts_j.string_of_payload authors)
            (Shared.PageAuthorExcerpts.make ~authors)
  end

  module Api = struct
    let authors_with_excerpts req =
      let open Lwt in
      Db.Get.authors req
      >>= respond_or_err (fun authors ->
            json (Shared.PageAuthorExcerpts_j.string_of_payload authors))

    let excerpts_by_author name req =
      let open Lwt in
      Db.Get.excerpts_by_author name req
      >>= respond_or_err (fun excerpts ->
            json (Shared.PageExcerpts_j.string_of_payload excerpts))
  end
end

(** The POST route handlers for our app *)
module Post = struct
  let excerpts_add req =
    let open Lwt in
    (* NOTE Should handle possible error arising from invalid data *)
    App.urlencoded_pairs_of_body req >>= excerpt_of_form_data >>= fun excerpt ->
    Db.Update.add_excerpt excerpt req
    >>= respond_or_err (fun () ->
          basic_page (Shared.PageExcerptAdded.make ~excerpt))
end

module Router = Shared.Router.Make (Handlers)

let create_middleware ~router =
  let filter handler req =
    let target = Request.uri req |> Uri.path |> Uri.pct_decode in
    let meth = Request.meth req in
    match Shared.Method_routes.match' ~meth ~target router with
    | None -> handler req
    | Some h -> h req
  in
  Rock.Middleware.create ~name:"Routes" ~filter

let m = create_middleware ~router:(Shared.Method_routes.one_of Router.routes)

let four_o_four =
  not_found (fun _req -> respond' @@ basic_page (Shared.PageNotFound.make ()))

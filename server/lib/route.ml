open Opium.Std

let respond_or_err resp = function
  | Ok v -> respond' @@ resp v
  | Error err -> respond' @@ Content.error_page err

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

(** The GET route handlers for our app *)
module Get = struct
  type request = Request.t

  type response = Response.t Lwt.t

  (** Defines a handler that replies to requests at the root endpoint *)
  let root _req = respond' @@ Content.welcome_page

  (** Defines a handler that takes a path parameter from the route *)
  let hello lang _req = respond' @@ Content.hello_page lang

  (** Fallback handler in case the endpoint is called without a language parameter *)
  let hello_fallback _req = respond' @@ Content.hello_page_fallback

  let excerpts_add _req = respond' @@ Content.add_excerpt_page

  let excerpts_by_author name req =
    let open Lwt in
    Db.Get.excerpts_by_author name req
    >>= respond_or_err Content.excerpts_listing_page

  let author_excerpts_page req =
    let open Lwt in
    Db.Get.authors req >>= respond_or_err Content.author_excerpts_page
end

(** The POST route handlers for our app *)
module Post = struct
  let excerpts_add req =
    let open Lwt in
    (* NOTE Should handle possible error arising from invalid data *)
    App.urlencoded_pairs_of_body req >>= excerpt_of_form_data >>= fun excerpt ->
    Db.Update.add_excerpt excerpt req
    >>= respond_or_err (fun () -> Content.excerpt_added_page excerpt)
end

module Router = Shared.Router.Make (Get)

let get_routes = Router.routes

let post_routes =
  let open Routes in
  [ (s "excerpts" / s "add" /? nil) @--> Post.excerpts_add ]

let create_middleware ~get_router ~post_router =
  let open Routes in
  let filter handler req =
    let target = Request.uri req |> Uri.path |> Uri.pct_decode in
    let meth = Request.meth req in
    match meth with
    | `GET ->
      ( match match' get_router ~target with
      | None -> handler req
      | Some h -> h req
      )
    | `POST ->
      ( match match' post_router ~target with
      | None -> handler req
      | Some h -> h req
      )
    | _ -> handler req
  in
  Rock.Middleware.create ~name:"Routes" ~filter

let m =
  create_middleware ~get_router:(Routes.one_of get_routes)
    ~post_router:(Routes.one_of post_routes)

let four_o_four = not_found (fun _req -> respond' @@ Content.not_found)

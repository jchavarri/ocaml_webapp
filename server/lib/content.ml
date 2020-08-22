open Core
open Tyxml

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

let welcome_page = basic_page (Shared.PageWelcome.make ())

let hello_page lang = basic_page (Shared.PageHello.make ~lang)

let hello_page_fallback = basic_page (Shared.PageHelloFallback.make ())

let add_excerpt_page = basic_page (Shared.PageAddExcerpt.make ())

let excerpt_added_page (e : Shared.Excerpt_t.t) =
  basic_page (Shared.PageExcerptAdded.make ~excerpt:e)

let excerpts_listing_page excerpts =
  page_with_payload
    (Shared.PageExcerpts_j.string_of_payload excerpts)
    (Shared.PageExcerpts.make ~excerpts)

let author_excerpts_page authors =
  page_with_payload
    (Shared.PageAuthorExcerpts_j.string_of_payload authors)
    (Shared.PageAuthorExcerpts.make ~authors)

let author_excerpts_json authors =
  `Json
    (Ezjsonm.from_string
       (Shared.PageAuthorExcerpts_j.string_of_payload authors))

let error_page err =
  basic_page
    Html.[ p [ txt (Printf.sprintf "Oh no! Something went wrong: %s" err) ] ]

let not_found = basic_page (Shared.PageNotFound.make ())

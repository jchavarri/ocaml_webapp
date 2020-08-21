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

let page_with_payload payload f =
  let open Html in
  basic_page
    ~payload:
      (script
         ~a:[ a_id "page_payload"; a_mime_type "application/json" ]
         (* todo: use atd to serialize payload *)
         (txt
            "{\r\n\
            \  \"author\" : \"Hey\";\r\n\
            \  \"excerpt\" : \"one excerpt\";\r\n\
            \  \"source\" : \"sdfdsf\";\r\n\
            \  \"page\" : 2;\r\n\
             }"))
    (f payload)

let welcome_page = basic_page (Shared.PageWelcome.make ())

let hello_page lang = basic_page (Shared.PageHello.make ~lang)

let hello_page_fallback = basic_page (Shared.PageHelloFallback.make ())

let add_excerpt_page = basic_page (Shared.PageAddExcerpt.make ())

let excerpt_added_page (e : Shared.Excerpt_t.t) =
  basic_page (Shared.PageExcerptAdded.make ~excerpt:e)

let excerpts_listing_page (es : Shared.Excerpt_t.t list) =
  page_with_payload es (fun es -> List.hd_exn (Shared.PageExcerpts.make ~es))

let author_excerpts_page authors =
  basic_page (Shared.PageAuthorExcerpts.make ~authors)

let error_page err =
  basic_page
    Html.[ p [ txt (Printf.sprintf "Oh no! Something went wrong: %s" err) ] ]

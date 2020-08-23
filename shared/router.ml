[@@@ocaml.warning "-44"]

open Routes

module type T = sig
  type request

  type response

  module Pages : sig
    val root : request -> response

    val hello : string -> request -> response

    val hello_fallback : request -> response

    val excerpts_add : request -> response

    val excerpts_by_author : string -> request -> response

    val authors_with_excerpts : request -> response
  end

  module Api : sig
    val authors_with_excerpts : request -> response

    val excerpts_by_author : string -> request -> response
  end
end

module PageRoutes = struct let authors_with_excerpts () = s "authors" /? nil end

module ApiRoutes = struct
  let authors_with_excerpts () = s "api" / s "authors" /? nil

  let excerpts_by_author () = s "api" / s "excerpts" / s "author" / str /? nil
end

module Make (Handlers : T) = struct
  open Handlers

  let routes =
    [
      `GET, empty @--> Pages.root;
      `GET, (s "hello" / str /? nil) @--> Pages.hello;
      `GET, (s "hello" /? nil) @--> Pages.hello_fallback;
      `GET, (s "excerpts" / s "add" /? nil) @--> Pages.excerpts_add;
      ( `GET,
        (s "excerpts" / s "author" / str /? nil) @--> Pages.excerpts_by_author );
      `GET, PageRoutes.authors_with_excerpts () @--> Pages.authors_with_excerpts;
      `GET, ApiRoutes.authors_with_excerpts () @--> Api.authors_with_excerpts;
      `GET, ApiRoutes.excerpts_by_author () @--> Api.excerpts_by_author;
    ]
end

module type T = sig
  type request

  type response

  val root : request -> response

  val hello : string -> request -> response

  val hello_fallback : request -> response

  val excerpts_add : request -> response

  (* val excerpts_by_author : string -> request -> response

     val excerpts : request -> response *)
end

module Make (Get : T) = struct
  [@@@ocaml.warning "-44"]

  open Routes

  let routes =
    [
      empty @--> Get.root;
      (s "hello" / str /? nil) @--> Get.hello;
      (s "hello" /? nil) @--> Get.hello_fallback;
      (s "excerpts" / s "add" /? nil) @--> Get.excerpts_add;
      (* (s "excerpts" / s "author" / str /? nil) @--> Get.excerpts_by_author;
         (s "excerpts" /? nil) @--> Get.excerpts; *)
    ]
end

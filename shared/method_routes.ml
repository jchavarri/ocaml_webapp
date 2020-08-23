type standard =
  [ `GET
  | `HEAD
  | `POST
  | `PUT
  | `DELETE
  | `CONNECT
  | `OPTIONS
  | `TRACE
  ]

type 'a router = {
  get : 'a Routes.router;
  post : 'a Routes.router;
}

let one_of routes =
  let routes = List.rev routes in
  let get, post =
    List.fold_left
      (fun (get, post) (meth, route) ->
        match meth with
        | `GET -> route :: get, post
        | `POST -> get, route :: post)
      ([], []) routes
  in
  { get = Routes.one_of get; post = Routes.one_of post }

let match' ~meth ~target { get; post } =
  match meth with
  | `GET -> Routes.match' ~target get
  | `POST -> Routes.match' ~target post
  | _ -> None

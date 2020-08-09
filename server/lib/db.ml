open! Core
open Opium.Std

(* Type aliases for the sake of documentation and explication *)
type 'err caqti_conn_pool =
  (Caqti_lwt.connection, ([> Caqti_error.connect ] as 'err)) Caqti_lwt.Pool.t

type ('res, 'err) query =
  Caqti_lwt.connection -> ('res, ([< Caqti_error.t ] as 'err)) result Lwt.t

(** Configuration of the connection *)
let connection_uri = Sys.getenv_exn "DATABASE_URL"

(* [connection ()] establishes a live database connection and is a pool of
   concurrent threads for accessing that connection. *)
let connect () =
  connection_uri |> Uri.of_string |> Caqti_lwt.connect_pool ~max_size:10
  |> function
  | Ok pool -> pool
  | Error err -> failwith (Caqti_error.show err)

(* [query_pool query pool] is the [Ok res] of the [res] obtained by executing
   the database [query], or else the [Error err] reporting the error causing
   the query to fail. *)
let query_pool query pool =
  Caqti_lwt.Pool.use query pool |> Lwt_result.map_err Caqti_error.show

(* Seal the key type with a non-exported type, so the pool cannot be retrieved
   outside of this module *)
type 'err db_pool = 'err caqti_conn_pool

let key : _ db_pool Opium.Hmap.key =
  Opium.Hmap.Key.create ("db pool", fun _ -> sexp_of_string "db_pool")

(* Initiate a connection pool and add it to the app environment *)
let middleware app =
  let pool = connect () in
  let filter handler (req : Request.t) =
    let env = Opium.Hmap.add key pool (Request.env req) in
    handler { req with env }
  in
  let m = Rock.Middleware.create ~name:"database connection pool" ~filter in
  middleware m app

(* Execute a query on the database connection pool stored in the request
   environment *)
let query_db query req =
  Request.env req |> Opium.Hmap.get key |> query_pool query

(** Collects all the SQL queries *)
module Query = struct
  type ('res, 'err) query_result =
    ('res, ([> Caqti_error.call_or_retrieve ] as 'err)) result Lwt.t

  let add_excerpt
    : Caqti_lwt.connection -> Shared.Excerpt_t.t -> (unit, 'err) query_result
    =
    let open Shared.Excerpt_t in
    [%rapper
      execute
        {sql|
        INSERT INTO excerpts(author, excerpt, source, page)
        VALUES (%string{author}, %string{excerpt}, %string{source}, %string?{page})
        |sql}
        record_in]

  let get_excerpts_by_author
    :  Caqti_lwt.connection -> author:string ->
    (Shared.Excerpt_t.t list, 'err) query_result
    =
    let open Shared.Excerpt_t in
    [%rapper
      get_many
        {sql|
        SELECT @string{author}, @string{excerpt}, @string{source}, @string?{page}
        FROM excerpts
        WHERE author = %string{author}
        |sql}
        record_out]

  let get_authors
    : Caqti_lwt.connection -> unit -> (string list, 'err) query_result
    =
    [%rapper
      get_many
        {sql|
        SELECT DISTINCT @string{author}
        FROM excerpts
        |sql}]
end

(* Execute queries for fetching data *)
module Get = struct
  let excerpts_by_author author
    : Request.t -> (Shared.Excerpt_t.t list, string) Lwt_result.t
    =
    query_db (Query.get_excerpts_by_author ~author)

  let authors : Request.t -> (string list, string) Lwt_result.t =
    query_db (fun c -> Query.get_authors c ())
end

(* Execute queries for updating data *)
module Update = struct
  let add_excerpt excerpt : Request.t -> (unit, string) Lwt_result.t =
    query_db (fun c -> Query.add_excerpt c excerpt)
end

module Migration = struct
  type 'a migration_error =
    [< Caqti_error.t > `Connect_failed `Connect_rejected `Post_connect ] as 'a

  type 'a migration_operation =
    Caqti_lwt.connection -> unit -> (unit, 'a migration_error) result Lwt.t

  type 'a migration_step = string * 'a migration_operation

  let execute migrations =
    let open Lwt in
    let rec run migrations pool =
      match migrations with
      | [] -> Lwt_result.return ()
      | (name, migration) :: migrations ->
        Lwt_io.printf "Running: %s\n" name >>= fun () ->
        query_pool (fun c -> migration c ()) pool >>= ( function
        | Ok () -> run migrations pool
        | Error err -> return (Error err) )
    in
    return (connect ()) >>= run migrations
end

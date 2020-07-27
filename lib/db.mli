open Opium.Std

(** {{1} Type aliases for clearer documentation and explication} *)

type 'err caqti_conn_pool =
  (Caqti_lwt.connection, ([> Caqti_error.connect ] as 'err)) Caqti_lwt.Pool.t

type ('res, 'err) query =
  Caqti_lwt.connection -> ('res, ([< Caqti_error.t ] as 'err)) result Lwt.t

(** {{1} API for the Opium app database middleware }*)

(** [middleware app] equips the [app] with the database pool needed by the
    functions in [Update] and [Get]. It cannot (and should not) be accessed
    except through the API in this module. *)
val middleware : App.builder

module Get : sig
  (** Execute queries that fetch from the database *)

  (** [excerpts_by_author author req] is the [Ok excerpts] list of all the
      [excerpts] by the [author], if it succeeds. *)
  val excerpts_by_author
    :  string ->
    Request.t ->
    (Excerpt.t list, string) Lwt_result.t

  (** [authors req] is the [Ok authors] list of all the [authors] in the
      database, if it succeeds. *)
  val authors : Request.t -> (string list, string) Lwt_result.t
end

module Update : sig
  (** Execute queries that update the database *)

  (** [add_excerpt excerpt req] is [Ok ()] if the new excerpt can be inserted
      into the database. *)
  val add_excerpt : Excerpt.t -> Request.t -> (unit, string) Lwt_result.t
end

(** {{1} API for database migrations } *)

module Migration : sig
  (** Interface for executing database migrations *)

  type 'a migration_error =
    [< Caqti_error.t > `Connect_failed `Connect_rejected `Post_connect ] as 'a

  type 'a migration_operation =
    Caqti_lwt.connection -> unit -> (unit, 'a migration_error) result Lwt.t

  type 'a migration_step = string * 'a migration_operation

  (** [execute steps] is [Ok ()] if all the migration tasks in [steps] can be
      executed or [Error err] where [err] explains the reason for failure. *)
  val execute : _ migration_step list -> (unit, string) result Lwt.t
end

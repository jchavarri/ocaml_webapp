open Ocaml_webapp

let drop_excerpts_table = [%rapper execute
    {sql|
    DROP TABLE excerpts
    |sql}
]

let rollbacks =
  ["drop excerpts table", drop_excerpts_table
  ]

let () =
  match Lwt_main.run (Db.Migration.execute rollbacks) with
  | Ok ()     -> print_endline "Migration complete"
  | Error err -> failwith err

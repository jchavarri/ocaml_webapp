open Opium.Std

let hello = get "/" (fun _ -> `String "Hello world" |> respond')

let () = App.empty |> hello |> App.run_command |> ignore

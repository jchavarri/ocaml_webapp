module React = struct
  let string = Tyxml.Html.txt

  let list a = a

  let useState : (unit -> 'state) -> 'state * (('state -> 'state) -> unit) =
   fun f -> f (), fun _ -> ()

  let useEffect0 : (unit -> (unit -> unit) option) -> unit = fun _ -> ()

  let useEffect1 : (unit -> (unit -> unit) option) -> 'a array -> unit =
   fun _ _ -> ()
end

module Js = struct
  module Global = struct
    type timeoutId = unit

    let clearTimeout : timeoutId -> unit = fun _ -> ()

    let setTimeout : (unit -> unit) -> int -> timeoutId = fun _ _ -> ()
  end
end

module Dom = struct
  open Tyxml.Html

  let opt_concat f el list =
    match el with
    | None -> list
    | Some el -> f el :: list

  module Div = struct
    let createElement ?cls ~children () =
      div ~a:([] |> opt_concat (fun cls -> a_class [ cls ]) cls) children
  end

  module Ul = struct
    let createElement ?cls ~children () =
      ul ~a:([] |> opt_concat (fun cls -> a_class [ cls ]) cls) children
  end

  module Form = struct
    let createElement ~action ~form_method ~children () =
      form ~a:[ a_action action; a_method form_method ] children
  end

  module Input = struct
    let createElement ~input_type ?name ?value () =
      input
        ~a:
          ([ a_input_type input_type ]
          |> opt_concat a_name name
          |> opt_concat a_value value
          )
        ()
  end

  module P = struct let createElement ~children () = p children end

  module Textarea = struct
    let createElement ~name ~value () =
      textarea ~a:[ a_name name ] (Tyxml.Html.txt value)
  end
end

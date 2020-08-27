module React = struct
  let string = Tyxml.Html.txt

  let list a = a

  let useState : (unit -> 'state) -> 'state * (('state -> 'state) -> unit) =
   fun f -> f (), fun _ -> ()

  let useReducer
    : ('state -> 'action -> 'state) -> 'state -> 'state * ('action -> unit)
    =
   fun _ s -> s, fun _ -> ()

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
    let createElement ?action ?form_method ~children () =
      form
        ~a:([] |> opt_concat a_action action |> opt_concat a_method form_method)
        children
  end

  (** Input is needed as ReasonReact does not have a high level type for type_ attribute, it's just plain string *)
  module Input = struct
    let createElement ?cls ~input_type ?name ?value () =
      input
        ~a:
          ([ a_input_type input_type ]
          |> opt_concat a_name name
          |> opt_concat a_value value
          |> opt_concat (fun cls -> a_class [ cls ]) cls
          )
        ()
  end

  module P = struct let createElement ~children () = p children end

  module Textarea = struct
    let createElement ?cls ~name ~value () =
      textarea
        ~a:([ a_name name ] |> opt_concat (fun cls -> a_class [ cls ]) cls)
        (Tyxml.Html.txt value)
  end
end

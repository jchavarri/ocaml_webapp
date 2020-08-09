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

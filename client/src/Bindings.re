[@bs.val] [@bs.return nullable]
external getElementById: string => option(Dom.element) =
  "document.getElementById";

[@bs.get] external innerHTML: Dom.element => string = "innerHTML";

[@bs.send] external remove: (Dom.element, unit) => unit = "remove";

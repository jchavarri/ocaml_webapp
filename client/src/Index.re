[%bs.raw {|require("./index.css")|}];

[@bs.val] [@bs.return nullable]
external getElementById: string => option(Dom.element) =
  "document.getElementById";

switch (getElementById("root")) {
| Some(el) => ReactDOMRe.hydrate(<App />, el)
| None => ()
};

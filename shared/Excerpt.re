
let createElement = (~e: Excerpt_t.t, ()) => {
  let page =
    switch (e.page) {
    | None => ""
    | Some(p) => Printf.sprintf(", %s", p)
    };

   <div className="content">
    <p> {ReactBridge.string(e.excerpt)} </p>
    <p> {ReactBridge.string(Printf.sprintf("-- %s (%s%s)", e.author, e.source, page))} </p>
  </div>
};

[@react.component]
let make = (~e) => {
  createElement(~e, ())
};


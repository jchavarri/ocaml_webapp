open Bridge;

let createElement = (~e: Excerpt_t.t, ()) => {
  let page =
    switch (e.page) {
    | None => ""
    | Some(p) => Printf.sprintf(", %s", p)
    };

  <div className="content">
    <p> {React.string(e.excerpt)} </p>
    <p>
      {React.string(Printf.sprintf("-- %s (%s%s)", e.author, e.source, page))}
    </p>
  </div>;
};

[@react.component]
let make = (~e) => {
  createElement(~e, ());
};

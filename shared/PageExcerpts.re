[@react.component]
let make = (~es: list(Excerpt_t.t)) => {
  let children = [
    <h1> {ReactBridge.string("Excerpts")} </h1>,
    ...List.map(e => <Excerpt e />, es),
  ];
  <> {children |> ReactBridge.list} </>;
};

open Bridge;

[@react.component]
let make = (~es: list(Excerpt_t.t)) => {
  let (count, setCount) = React.useState(() => 0);
  React.useEffect1(
    () => {
      let timer =
        Js.Global.setTimeout(() => {setCount(count => count + 1)}, 1000);
      Some(() => Js.Global.clearTimeout(timer));
    },
    [|count|],
  );

  let children = [
    <h1> {React.string("Excerpts")} </h1>,
    <p>
      {React.string(
         "The HTML (including counter value) comes first from the OCaml native server"
         ++ " then is updated by React after hydration",
       )}
    </p>,
    <p> {React.string(string_of_int(count))} </p>,
    ...List.map(e => <Excerpt e />, es),
  ];
  <> {children |> React.list} </>;
};

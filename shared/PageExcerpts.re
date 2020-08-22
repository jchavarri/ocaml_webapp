open Bridge;

[@react.component]
let make = (~excerpts: list(Excerpt_t.t)) => {
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
    <h1 key="header"> {React.string("Excerpts")} </h1>,
    <p key="desc">
      {React.string(
         "The HTML (including counter value) comes first from the OCaml native server"
         ++ " then is updated by React after hydration",
       )}
    </p>,
    <p key="counter"> {React.string(string_of_int(count))} </p>,
    ...List.mapi(
         (_i, e) => <Excerpt key={string_of_int(_i)} e />,
         excerpts,
       ),
  ];
  children |> React.list;
};

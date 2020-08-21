open Bridge;

[@react.component]
let make = () => {
  <>
    <h1> {React.string("OCaml Webapp Tutorial")} </h1>
    <h2> {React.string("Hello")} </h2>
    <Dom.Ul>
      {List.mapi(
         (_i, x) => <li key={string_of_int(_i)}> x </li>,
         [
           <Link url="/hello" txt="hiya" />,
           <Link url={j|/hello/中文|j} txt={j|中文|j} />,
           <Link url="/hello/Deutsch" txt="Deutsch" />,
           <Link url="/hello/English" txt="English" />,
         ],
       )
       |> React.list}
    </Dom.Ul>
    <h2> {React.string("Excerpts")} </h2>
    <Dom.Ul>
      {List.mapi(
         (_i, x) => <li key={string_of_int(_i)}> x </li>,
         [
           <Link url="/excerpts/add" txt="Add Excerpt" />,
           <Link url="/excerpts" txt="Excerpts" />,
         ],
       )
       |> React.list}
    </Dom.Ul>
  </>;
};

open Bridge;

[@react.component]
let make = () => {
  <>
    <h1> {React.string("OCaml Webapp Tutorial")} </h1>
    <h2> {React.string("Hello")} </h2>
    <Dom.Ul>
      {List.map(
         x => <li> x </li>,
         [
           <Link url="/hello" txt="hiya" />,
           <Link url="/hello/中文" txt="中文" />,
           <Link url="/hello/Deutsch" txt="Deutsch" />,
           <Link url="/hello/English" txt="English" />,
         ],
       )
       |> React.list}
    </Dom.Ul>
    <h2> {React.string("Excerpts")} </h2>
    <Dom.Ul>
      {List.map(
         x => <li> x </li>,
         [
           <Link url="/excerpts/add" txt="Add Excerpt" />,
           <Link url="/excerpts" txt="Excerpts" />,
         ],
       )
       |> React.list}
    </Dom.Ul>
  </>;
};

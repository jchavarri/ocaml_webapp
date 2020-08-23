open Bridge;

[@react.component]
let make = () => {
  <PageContainer>
    <h1 className="font-semibold text-xl tracking-tight mb-8">
      {React.string("OCaml native webapp with SSR + ReasonReact hydration")}
    </h1>
    <h2> {React.string("Hello")} </h2>
    <Dom.Ul cls="list-disc list-inside mb-8">
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
    <Dom.Ul cls="list-disc list-inside">
      {List.mapi(
         (_i, x) => <li key={string_of_int(_i)}> x </li>,
         [
           <Link url="/excerpts/add" txt="Add Excerpt" />,
           <Link
             url={Routes.sprintf(Router.PageRoutes.authors_with_excerpts())}
             txt="Authors with excerpts"
           />,
         ],
       )
       |> React.list}
    </Dom.Ul>
  </PageContainer>;
};

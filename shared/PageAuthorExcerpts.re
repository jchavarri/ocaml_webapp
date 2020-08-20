open Bridge;

module AuthorExcerptsLink = {
  let createElement = (~author, ()) => {
    <Link url={Printf.sprintf("/excerpts/author/%s", author)} txt=author />;
  };
  [@react.component]
  let make = (~author) => {
    createElement(~author, ());
  };
};

[@react.component]
let make = (~authors) => {
  <>
    <h1> {React.string("Authors with excerpts")} </h1>
    <Dom.Ul>
      {List.map(author => <li> <AuthorExcerptsLink author /> </li>, authors)
       |> React.list}
    </Dom.Ul>
  </>;
};

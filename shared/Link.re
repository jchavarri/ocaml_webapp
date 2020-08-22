open Bridge;

let createElement = (~url, ~txt, ()) => {
  <a
    href=url
    onClick={e => {
      ReactEvent.Mouse.preventDefault(e);
      ReasonReactRouter.push(url);
    }}>
    {React.string(txt)}
  </a>;
};

[@react.component]
let make = (~url, ~txt) => {
  createElement(~url, ~txt, ());
};

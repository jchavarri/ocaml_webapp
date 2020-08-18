open Bridge;

let createElement = (~url, ~txt, ()) => {
  <a href=url> {React.string(txt)} </a>;
};

[@react.component]
let make = (~url, ~txt) => {
  createElement(~url, ~txt, ());
};

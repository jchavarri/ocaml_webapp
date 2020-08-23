open Bridge;

let createElement = (~children, ()) => {
  <Dom.Div cls="flex xs:justify-center overflow-hidden">
    <>
      <Dom.Div
        cls="mt-32 min-w-md lg:align-center w-full px-4 md:px-8 max-w-2xl">
        children
      </Dom.Div>
    </>
  </Dom.Div>;
};

[@react.component]
let make = (~children) => {
  createElement(~children, ());
};

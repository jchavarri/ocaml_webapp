open Bridge;

[@react.component]
let make = (~excerpt as e) => {
  <>
    <p> {React.string("Added the following excerpt: ")} </p>
    <Excerpt e />
  </>;
};

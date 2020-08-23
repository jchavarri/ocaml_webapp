open Bridge;

[@react.component]
let make = (~excerpt as e) => {
  <PageContainer>
    <>
      <p> {React.string("Added the following excerpt: ")} </p>
      <Excerpt e />
    </>
  </PageContainer>;
};

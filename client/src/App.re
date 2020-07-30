[@react.component]
let make = () => {
  let excerpts = [
    {
      Excerpt_t.author: "Hey",
      excerpt: "one excerpt",
      source: "sdfdsf",
      page: Some("2"),
    },
  ];
  <PageExcerpts es=excerpts />;
};

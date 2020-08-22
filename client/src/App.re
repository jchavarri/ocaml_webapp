/** The route handlers for our app */
module Get = {
  type request = string;
  type response = React.element;

  /** Defines a handler that replies to requests at the root endpoint */
  let root = _req => <PageWelcome />;

  /** Defines a handler that takes a path parameter from the route */
  let hello = (lang, _req) => <PageHello lang />;

  /** Fallback handler in case the endpoint is called without a language parameter */
  let hello_fallback = _req => <PageHelloFallback />;

  let excerpts_add = _req => <PageAddExcerpt />;
  // let excerpts_by_author = (name, req) =>
  //   Lwt.(
  //     Db.Get.excerpts_by_author(name, req)
  //     >>= respond_or_err(Content.excerpts_listing_page)
  //   );
  // let excerpts = req =>
  //   Lwt.(
  //     Db.Get.authors(req) >>= respond_or_err(Content.author_excerpts_page)
  //   );
};

module Router = Router.Make(Get);
let router = Routes.one_of(Router.routes);
[@react.component]
let make = () => {
  let url = ReasonReactRouter.useUrl();
  let target = url.path->Array.of_list->Js.Array2.joinWith("/");
  // let excerpts = [
  //   {
  //     Excerpt_t.author: "Hey",
  //     excerpt: "one excerpt",
  //     source: "sdfdsf",
  //     page: Some("2"),
  //   },
  // ];
  switch (
    Routes.match'(router, ~target=Js.Global.decodeURIComponent(target))
  ) {
  | None => <PageNotFound />
  | Some(h) => h(target)
  };
};

/** The route handlers for our app */
module Handlers = {
  /** The payload available in the <script id="ocaml_webapp_page_payload" /> element */
  type request = option(string);
  type response = React.element;

  module Pages = {
    /** Defines a handler that replies to requests at the root endpoint */
    let root = _req => <PageWelcome />;

    /** Defines a handler that takes a path parameter from the route */
    let hello = (lang, _req) => {
      <PageHello lang />;
    };

    /** Fallback handler in case the endpoint is called without a language parameter */
    let hello_fallback = _req => <PageHelloFallback />;

    let excerpts_add = _req => <PageAddExcerpt />;

    let excerpts_by_author = (authorName, payload) =>
      switch (payload) {
      | Some(p) =>
        switch (p->Js.Json.parseExn->PageExcerpts_bs.read_payload) {
        | excerpts => <PageExcerpts excerpts />
        | exception _exn =>
          Js.log("Couldn't parse excerpts from JSON payload " ++ p);
          <PageNotFound />;
        }
      | None =>
        <Client.FetchRender
          url={Routes.sprintf(
            Router.ApiRoutes.excerpts_by_author(),
            authorName,
          )}
          decoder=PageExcerpts_bs.read_payload>
          {(
             excerpts => {
               <PageExcerpts excerpts />;
             }
           )}
        </Client.FetchRender>
      };

    let authors_with_excerpts = payload =>
      switch (payload) {
      | Some(p) =>
        switch (p->Js.Json.parseExn->PageAuthorExcerpts_bs.read_payload) {
        | authors => <PageAuthorExcerpts authors />
        | exception _exn =>
          Js.log("Couldn't parse authors from JSON payload " ++ p);
          <PageNotFound />;
        }
      | None =>
        <Client.FetchRender
          url={Routes.sprintf(Router.ApiRoutes.authors_with_excerpts())}
          decoder=PageAuthorExcerpts_bs.read_payload>
          {(authors => <PageAuthorExcerpts authors />)}
        </Client.FetchRender>
      };
  };
  module Api = {
    // Api routes should never be loaded from React app, show the backing page in case it happens
    let excerpts_by_author = Pages.excerpts_by_author;
    let authors_with_excerpts = Pages.authors_with_excerpts;
  };
};

module Router = Router.Make(Handlers);
let router = Method_routes.one_of(Router.routes);

[@react.component]
let make = () => {
  let url = ReasonReactRouter.useUrl();
  let target = url.path->Array.of_list->Js.Array2.joinWith("/");
  let payloadElement = Bindings.getElementById(Api.payload_id);

  switch (
    Method_routes.match'(
      ~meth=`GET,
      ~target=Js.Global.decodeURIComponent(target),
      router,
    )
  ) {
  | None => <PageNotFound />
  | Some(handler) =>
    let payload = payloadElement->Belt.Option.map(Bindings.innerHTML);
    /* After processing the payload from server, it can be safely removed so other pages don't try to decode it again
       as the client will take over navigation + data fetching through API */
    payloadElement->Belt.Option.forEach(e => e->Bindings.remove());
    handler(payload);
  };
};

open Bridge;
open Dom;

type action =
  | AuthorChanged(string)
  | ExcerptChanged(string)
  | SourceChanged(string)
  | PageChanged(string);

type state = {
  author: string,
  excerpt: string,
  source: string,
  page: string,
};

let row = (left, right) =>
  <>
    <Div cls="md:w-1/3"> <> left </> </Div>
    <Div cls="md:w-2/3"> <> right </> </Div>
  </>;

let reducer = (state, action) =>
  switch (action) {
  | AuthorChanged(author) => {...state, author}
  | ExcerptChanged(excerpt) => {...state, excerpt}
  | SourceChanged(source) => {...state, source}
  | PageChanged(page) => {...state, page}
  };

[@react.component]
let make = () => {
  let (state, dispatch) =
    React.useReducer(
      reducer,
      {author: "", excerpt: "", source: "", page: ""},
    );

  let txtInput = (name, value, _onChange) =>
    row(
      <label
        className="block text-gray-500 md:text-right mb-1 md:mb-0 pr-4"
        htmlFor="inline-full-name">
        {React.string(String.capitalize_ascii(name))}
      </label>,
      <Input
        cls="bg-gray-200 appearance-none border-2 border-gray-200 rounded w-full py-2 px-4 text-gray-700 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
        input_type=`Text
        name
        onChange={e => _onChange(ReactEvent.Form.target(e)##value)}
        value
      />,
    );

  let excerptInput = {
    let name = "excerpt";
    row(
      <label
        className="block text-gray-500 md:text-right mb-1 md:mb-0 pr-4"
        htmlFor=name>
        {React.string(String.capitalize_ascii(name))}
      </label>,
      <Textarea
        cls="bg-gray-200 appearance-none border-2 border-gray-200 rounded w-full py-2 px-4 text-gray-700 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
        name
        value={state.excerpt}
        onChange={e =>
          dispatch @@ ExcerptChanged(ReactEvent.Form.target(e)##value)
        }
      />,
    );
  };

  let submit =
    row(
      <div />,
      <Input
        cls="shadow bg-blue-500 hover:bg-blue-400 focus:shadow-outline focus:outline-none text-white font-bold py-2 px-4 rounded"
        input_type=`Submit
        value="Submit"
      />,
    );

  <PageContainer>
    <>
      <h1 className="font-semibold text-xl tracking-tight mb-8">
        {React.string("Add new excerpt")}
      </h1>
      {<Form
         onSubmit={e => {
           ReactEvent.Form.preventDefault(e);
           Client.request(
             ~method_=Post,
             ~input={
               Excerpt_bs.write_t({
                 author: state.author,
                 excerpt: state.excerpt,
                 source: state.source,
                 page: Some(state.page),
               });
             },
             Routes.sprintf(Router.ApiRoutes.add_excerpt()),
             a =>
             a
           )
           |> Js.Promise.then_(res =>
                Js.log2("received", res)->Js.Promise.resolve
              )
           |> ignore;
           Js.log(state);
         }}>
         {List.mapi(
            (_i, x) =>
              <Div cls="md:flex md:items-center mb-6" key={string_of_int(_i)}>
                x
              </Div>,
            [
              txtInput("author", state.author, author =>
                dispatch @@ AuthorChanged(author)
              ),
              excerptInput,
              txtInput("source", state.source, author =>
                dispatch @@ SourceChanged(author)
              ),
              txtInput("page", state.page, author =>
                dispatch @@ PageChanged(author)
              ),
              submit,
            ],
          )
          |> React.list}
       </Form>}
    </>
  </PageContainer>;
};

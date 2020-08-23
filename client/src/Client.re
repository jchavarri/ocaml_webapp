module Result = Belt.Result;

type data('a, 'b) =
  | Loading
  | Finished(Result.t('a, 'b));

let request = (~method_=Fetch.Get, ~input=?, url, decoder) => {
  Js.Promise.(
    Fetch.fetchWithInit(
      url,
      Fetch.RequestInit.make(
        ~method_,
        ~body=?{
          input->Belt.Option.map(input =>
            input->Js.Json.stringify->Fetch.BodyInit.make
          );
        },
        (),
      ),
    )
    |> then_(res => {
         res->Fetch.Response.status >= 400
           ? Js.log(
               "Server returned status code "
               ++ res->Fetch.Response.status->string_of_int
               ++ " for url: "
               ++ url,
             )
           : ();
         Fetch.Response.text(res)
         |> then_(jsonText =>
              try(jsonText->Js.Json.parseExn->decoder->Result.Ok->resolve) {
              | Js.Exn.Error(error) =>
                let errMsg = error->Js.Exn.message;
                `DecodingError(errMsg)->Result.Error->resolve;
              }
            );
       })
    |> catch(err => {
         Js.log("Network error for url: " ++ url);
         `NetworkError(err)->Result.Error->resolve;
       })
  );
};

let usePrevious = value => {
  let valueRef = React.useRef(value);
  React.useEffect(() => {
    valueRef.current = value;
    None;
  });
  valueRef.current;
};

module FetchRender = {
  [@react.component]
  let make = (~url, ~decoder, ~children) => {
    let (data, setData) = React.useState(() => Loading);
    let urlChanged = usePrevious(url) != url;
    let data = urlChanged ? Loading : data;

    React.useEffect2(
      () => {
        setData(_ => Loading);
        request(url, decoder)
        |> Js.Promise.then_(res =>
             setData(_ => Finished(res))->Js.Promise.resolve
           )
        |> ignore;
        None;
      },
      (url, decoder),
    );
    switch (data) {
    | Loading => <div> {React.string("Loading")} </div>
    | Finished(Ok(payload)) => children(payload)
    | Finished(Error(_)) => <div> {React.string("Error")} </div>
    };
  };
};

module Result = Belt.Result;

type data('a, 'b) =
  | Loading
  | Finished(Result.t('a, 'b));

let get = (url, decoder) => {
  Js.Promise.(
    Fetch.fetchWithInit(url, Fetch.RequestInit.make(~method_=Get, ()))
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

module ApiData = {
  [@react.component]
  let make = (~url, ~decoder, ~onOk) => {
    let (data, setData) = React.useState(() => Loading);
    React.useEffect0(() => {
      get(url, decoder)
      |> Js.Promise.then_(res =>
           setData(_ => Finished(res))->Js.Promise.resolve
         )
      |> ignore;
      None;
    });
    switch (data) {
    | Loading => <div> {React.string("Loading")} </div>
    | Finished(Ok(payload)) => onOk(payload)
    | Finished(Error(_)) => <div> {React.string("Error")} </div>
    };
  };
};

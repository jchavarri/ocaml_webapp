open Bridge;
open Dom;

[@react.component]
let make = () => {
  let txtInput = name =>
    <>
      <label htmlFor=name>
        {React.string(String.capitalize_ascii(name))}
      </label>
      <Input input_type=`Text name />
    </>;

  let excerptInput = {
    let name = "excerpt";
    <>
      <label htmlFor=name>
        {React.string(String.capitalize_ascii(name))}
      </label>
      <Dom.Textarea name value="" onChange={e => Js.log(e)} />
    </>;
  };

  let submit = <> <Input input_type=`Submit value="Submit" /> </>;

  <>
    {<Form form_method=`Post action="/excerpts/add">
       {List.mapi(
          (_i, x) => <P key={string_of_int(_i)}> x </P>,
          [
            txtInput("author"),
            excerptInput,
            txtInput("source"),
            txtInput("page"),
            submit,
          ],
        )
        |> React.list}
     </Form>}
  </>;
};

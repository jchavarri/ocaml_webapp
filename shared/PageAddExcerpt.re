open Bridge;

[@react.component]
let make = () => {
  let txtInput = name =>
    <>
      <label for_=name>
        {React.string(String.capitalize_ascii(name))}
      </label>
      <input type_=`Text name />
    </>;

  let excerptInput = {
    let name = "excerpt";
    <>
      <label for_=name>
        {React.string(String.capitalize_ascii(name))}
      </label>
      <textarea name> {React.string("")} </textarea>
    </>;
  };

  let submit = <> <input type_=`Submit value="Submit" /> </>;

  <>
    {<form method=`Post action="/excerpts/add">
       ...{List.map(
         x => <p> ...x </p>,
         [
           txtInput("author"),
           excerptInput,
           txtInput("source"),
           txtInput("page"),
           submit,
         ],
       )}
     </form>}
  </>;
};

open Bridge;

[@react.component]
let make = (~lang) => {
  let greeting =
    switch (lang) {
    | "中文" => "你好，世界!"
    | "Deutsch" => "Hallo, Welt!"
    | "English" => "Hello, World!"
    | _ => "Language not supported :(\nYou can add a language via PR to https://github.com/jchavarri/ocaml_webapp"
    };
  <> <p> {React.string(greeting)} </p> </>;
};

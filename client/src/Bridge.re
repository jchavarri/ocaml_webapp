module React = {
  include React;
  let list = el => el->Array.of_list->React.array;
};

module Dom = {
  module Div = {
    [@react.component]
    let make = (~cls as className=?, ~children) => {
      <div ?className> children </div>;
    };
  };
  module Ul = {
    [@react.component]
    let make = (~cls as className=?, ~children) => {
      <ul ?className> children </ul>;
    };
  };
  module Form = {
    // From tyxml:
    // https://github.com/ocsigen/tyxml/blob/4d48e60269dc5d2f7ad62f8ef5af05b7b9e11042/lib/html_sigs.mli#L501-L502
    // https://github.com/ocsigen/tyxml/blob/4d48e60269dc5d2f7ad62f8ef5af05b7b9e11042/lib/html_f.ml#L948-L949
    let stringOfMethod =
      fun
      | `Get => "GET"
      | `Post => "POST";
    [@react.component]
    let make = (~action=?, ~form_method=?, ~onSubmit=?, ~children) => {
      <form
        ?action
        method=?{form_method->Belt.Option.map(stringOfMethod)}
        ?onSubmit>
        children
      </form>;
    };
  };
  module Input = {
    // From tyxml:
    // https://github.com/ocsigen/tyxml/blob/4d48e60269dc5d2f7ad62f8ef5af05b7b9e11042/lib/html_sigs.mli#L526-L550
    // https://github.com/ocsigen/tyxml/blob/4d48e60269dc5d2f7ad62f8ef5af05b7b9e11042/lib/html_f.ml#L1026
    let stringOfInputType =
      fun
      | `Button => "button"
      | `Checkbox => "checkbox"
      | `Color => "color"
      | `Date => "date"
      | `Datetime => "datetime"
      | `Datetime_local => "datetime-local"
      | `Email => "email"
      | `File => "file"
      | `Hidden => "hidden"
      | `Image => "image"
      | `Month => "month"
      | `Number => "number"
      | `Password => "password"
      | `Radio => "radio"
      | `Range => "range"
      | `Readonly => "readonly"
      | `Reset => "reset"
      | `Search => "search"
      | `Submit => "submit"
      | `Tel => "tel"
      | `Text => "text"
      | `Time => "time"
      | `Url => "url"
      | `Week => "week";
    [@react.component]
    let make =
        (~cls as className=?, ~input_type, ~name=?, ~value=?, ~onChange=?) => {
      <input
        ?className
        type_={stringOfInputType(input_type)}
        ?name
        ?value
        ?onChange
      />;
    };
  };
  module P = {
    [@react.component]
    let make = (~children) => {
      <p> children </p>;
    };
  };
  module Textarea = {
    [@react.component]
    let make = (~cls as className=?, ~name, ~onChange=?, ~value) => {
      <textarea ?className name ?onChange value />;
    };
  };
};

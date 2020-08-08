module React = {
  include React;
  let list = el => el->Array.of_list->React.array;
};

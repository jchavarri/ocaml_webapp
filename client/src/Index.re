switch (Bindings.getElementById("root")) {
| Some(el) => ReactDOMRe.hydrate(<App />, el)
| None => ()
};

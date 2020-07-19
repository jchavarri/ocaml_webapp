# ocaml_webapp
A minimal example of a lightweight webapp in OCaml

### Getting started

Create an opam local switch:

```bash
make create-switch
```

Install `dune` in the newly created switch:

```bash
opam install dune
```

Install all dependencies:

```bash
make deps
```

Run the server:
```bash
make run
```

Open the browser and go to http://localhost:3000/.

### Resources

- Amazing tutorial to create a lightweight OCaml webapp: https://shonfeder.gitlab.io/ocaml_webapp/
- Deploying native Reason/OCaml with Zeit's now.sh: https://jaredforsyth.com/posts/deploying-native-reason-ocaml-with-now-sh/
- Deploying OCaml server on Heroku: https://medium.com/@aleksandrasays/deploying-ocaml-server-on-heroku-f91dcac11f11

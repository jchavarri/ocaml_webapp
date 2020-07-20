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

### Deploying to Heroku

Right now, the example allows to easily deploy the app to Heroku. Build times are longer than they should, but hopefully
this will be fixed [soon](https://github.com/jchavarri/ocaml_webapp/issues/1).

- Install the Heroku CLI: http://toolbelt.heroku.com/
- Run `heroku create your_app` from the app folder
- Set stack for the app to `container`: `heroku stack:set container`
- `git push heroku master`

### Resources

- Amazing tutorial to create a lightweight OCaml webapp: https://shonfeder.gitlab.io/ocaml_webapp/
- Deploying native Reason/OCaml with Zeit's now.sh: https://jaredforsyth.com/posts/deploying-native-reason-ocaml-with-now-sh/
- Deploying OCaml server on Heroku: https://medium.com/@aleksandrasays/deploying-ocaml-server-on-heroku-f91dcac11f11

# ocaml_webapp

A minimal example of a lightweight webapp in OCaml.

It features a possible organization of files to maximize code sharing between server (native OCaml) and client (BuckleScript). Some of the things shared are:

- React components, which are server-side rendered with [Tyxml](https://github.com/ocsigen/tyxml) and hydrated with [ReasonReact](https://reasonml.github.io/reason-react/)
- Routes, through the OCaml library [Routes](https://github.com/anuragsoni/routes).
- API endpoints interface types, through library [ATD](https://github.com/ahrefs/atd), that also generates encoders / decoders automatically.

Potentially, `shared` folder can contain other shared code like validation functions, data processing, etc.

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

Build client:

```
yarn webpack:dev
```

Build and run the server:
```bash
make run
```

Open the browser and go to http://localhost:3000/.

It's also possible to get hot reloading while developing. For that, start the server (to be able to serve API requests) with `make run`, run BuckleScript in `yarn start` and then start Webpack dev server with `yarn server`.

### Run databases locally

```
docker-compose -f docker-compose.dev.yml up -d
```

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

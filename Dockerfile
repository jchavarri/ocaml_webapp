FROM ocaml/opam2:alpine-3.12-ocaml-4.10 as base

WORKDIR /ocaml_webapp

# Install dependencies
COPY ocaml_webapp.opam .
RUN opam pin add -yn ocaml_webapp . && \
    opam depext ocaml_webapp && \
    opam install . --deps-only

# Build the app! Note: The chown is somehow necessary, as
# without it the `dune build` command will fail with
# permission errors.
# We also need to take note of the dependencies from depext.
COPY . .
RUN sudo chown -R opam:nogroup . && \
    opam exec dune build && \
    opam depext -ln ocaml_webapp > depexts && \
    apk add --update nodejs nodejs-npm && \
    yarn install && yarn build && yarn webpack:production

# Let's create the production image!
FROM alpine as stage
WORKDIR /app
COPY --from=base /ocaml_webapp/_build/default/bin/main.exe ocaml_webapp.exe
COPY --from=base /ocaml_webapp/_build/default/migrate/migrate.exe migrate.exe
COPY --from=base /ocaml_webapp/static static

# Don't forget to install the dependencies, noted from
# the previous build.
COPY --from=base /ocaml_webapp/depexts depexts
RUN cat depexts | xargs apk --update add && rm -rf /var/cache/apk/*

CMD ./ocaml_webapp.exe --port=$PORT

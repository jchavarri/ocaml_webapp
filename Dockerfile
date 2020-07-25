FROM ocaml/opam2:alpine-3.12

# Install dependencies
RUN apk update && apk add --no-cache m4

WORKDIR ocaml_webapp

COPY ocaml_webapp.opam .
RUN sudo chown -R opam:nogroup ocaml_webapp.opam && \
    opam install . --deps-only

# Build the app! Note: The chown is somehow necessary, as
# without it the `dune build` command will fail with
# permission errors.
# We also need to take note of the dependencies from depext.
COPY . .
RUN sudo chown -R opam:nogroup . && \
    opam exec dune build && \
    opam depext -ln ocaml_webapp | egrep -o "\-\s.*" | sed "s/- //" > depexts
    
# Let's create the production image!
FROM alpine
WORKDIR /app
COPY --from=0 /home/opam/opam-repository/ocaml_webapp/_build/default/bin/main.exe ocaml_webapp.exe

# Don't forget to install the dependencies, noted from
# the previous build.
COPY --from=0 /home/opam/opam-repository/ocaml_webapp/depexts depexts
RUN cat depexts | xargs apk --update add && rm -rf /var/cache/apk/*

CMD ./ocaml_webapp.exe --port=$PORT

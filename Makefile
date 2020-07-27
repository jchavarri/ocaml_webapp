project_name = ocaml_webapp

opam_file = $(project_name).opam

db_uri = "postgresql://admin:secret@localhost:5432/ocaml_webapp"

.PHONY: create-switch deps fmt run run-debug migrate rollback

# Create a local opam switch
create-switch:
	opam switch create . 4.10.0 --deps-only

# Alias to update the opam file and install the needed deps
deps: $(opam_file)

fmt:
	dune build @fmt --auto-promote
	
# Build and run the app
run:
	DATABASE_URL=$(db_uri) dune exec $(project_name)

# Build and run the app with Opium's internal debug messages visible
run-debug:
	DATABASE_URL=$(db_uri) dune exec $(project_name) -- --debug

# Run the database migrations defined in migrate/migrate.ml
migrate:
	DATABASE_URL=$(db_uri) dune exec migrate_ocaml_webapp

# Run the database rollback defined in migrate/rollback.ml
rollback:
	DATABASE_URL=$(db_uri) dune exec rollback_ocaml_webapp

# Update the package dependencies when new deps are added to dune-project
$(opam_file): dune-project
	-dune build @install        # Update the $(project_name).opam file
	-git add $(opam_file)       # opam uses the state of master for it updates
	-git commit $(opam_file) -m "Updating package dependencies"
	opam install . --deps-only  # Install the new dependencies

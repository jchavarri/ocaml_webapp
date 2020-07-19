project_name = ocaml_webapp

opam_file = $(project_name).opam

.PHONY: deps run run-debug migrate rollback

# Alis to update the opam file and install the needed deps
deps: $(opam_file)

# Build and run the app
run:
	dune exec $(project_name)

# Build and run the app with Opium's internal debug messages visible
run-debug:
	dune exec $(project_name) -- --debug

# Update the package dependencies when new deps are added to dune-project
$(opam_file): dune-project
	-dune build @install        # Update the $(project_name).opam file
	-git add $(opam_file)       # opam uses the state of master for it updates
	-git commit $(opam_file) -m "Updating package dependencies"
	opam install . --deps-only  # Install the new dependencies

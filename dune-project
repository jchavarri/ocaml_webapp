(lang dune 2.0)
(generate_opam_files true)

(name ocaml_webapp)
(version 0.1.0)

(authors "Javier Chávarri")
(license MIT)
(source (uri "git+https://github.com/jchavarri/ocaml_webapp.git"))
(maintainers "javier.chavarri@gmail.com")
(homepage "https://github.com/jchavarri/ocaml_webapp")
(bug_reports "https://github.com/jchavarri/ocaml_webapp/issues")
(documentation "https://github.com/jchavarri/ocaml_webapp")

(package
 (name ocaml_webapp)
 (synopsis "A minimal example of a lightweight webapp in OCaml")
 (description "A minimal webapp using Opium, Catqi, and tyXML")
 (depends
  ;; General system dependencies
  (dune (>= 2))
  (ocaml (>= 4.10.0))

  ;; Database interface
  (caqti (>= 1.2.1))
  (caqti-lwt (>= 1.2.0))
  (caqti-driver-postgresql (>= 1.2.1))
  (ppx_rapper (>= 0.9.2))

  ;; Web toolkit
  (opium (>= 0.17.1))
  (reason (>= 3.6.0))

  ;; HTML generation
  (tyxml (>= 4.4.0))
  (tyxml-jsx (>= 4.4.0))
  
  ;; Dev dependencies
  (ocamlformat :dev)
))

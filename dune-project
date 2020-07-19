(lang dune 2.0)
(generate_opam_files true)

(name ocaml_webapp)
(version 0.1.0)

(authors "Javier Chávarri")
(license MIT)
(source (uri "git@github.com:jchavarri/ocaml_webapp.git"))
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
  (ocaml (>= 4.08.0))

  ;; Web toolkit
  (opium (>= 0.17.1))

  (yojson (>= 1.7.0))
  (ppx_yojson_conv (>= 0.14.0))

  ;; Dev dependencies
  (ocamlformat :dev)
))

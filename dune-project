(lang dune 3.10)

(name vexilla_ocaml_sdk)

(generate_opam_files true)

(source
 (github dmmulroy/vexilla-ocaml-sdk))

(authors "Dillon Mulroy")

(maintainers "Dillon Mulroy")

(license MIT)

(documentation https://github.com/dmmulroy/vexilla-ocaml-sdk)

(package
 (name vexilla_ocaml_sdk)
 (synopsis "Vexilla OCaml SDK")
 (description
  "Vexilla OCaml SDK")
 (depends
  cohttp-lwt-unix
  dune
  fmt
  lwt_ssl
  ocaml
  ppx_deriving
  ppx_deriving_yojson
  ptime
  uri
  yojson)
 (tags
  (feature-flags)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project

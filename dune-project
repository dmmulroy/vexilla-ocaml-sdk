(lang dune 3.9)

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
 (synopsis "Seamlessly transfer playlists between music streaming services")
 (description
  "Seamlessly transfer playlists between music streaming services")
 (depends
  cohttp-lwt-unix
  dune
  lwt_ssl
  ocaml
  ppx_deriving)
 (tags
  (music, ocaml, cli, learning, spotify, apple-music)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project

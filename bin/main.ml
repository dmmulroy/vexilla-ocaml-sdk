[@@@ocaml.warning "-26"]

let () =
  let client =
    Vexilla.Client.make ~environment:"test-env"
      ~base_url:(Uri.of_string "http://localhost:8080")
      ~instance_id:"test-id" ()
  in
  ()

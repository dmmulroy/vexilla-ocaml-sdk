[@@@ocaml.warning "-26"]

let () =
  let client =
    Vexilla.Client.make
      ~base_url:(Uri.of_string "http://localhost:8080")
      ~environment:(`Id "test-env") ~instance_id:"test-id" ()
  in
  ()

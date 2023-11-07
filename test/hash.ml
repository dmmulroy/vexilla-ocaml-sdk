let test_hash_should () =
  Alcotest.(check (float 0.00))
    "should" 0.28
    (Vexilla.Hash.hash_instance_id ~seed:0.11
       "b7e91cc5-ec76-4ec3-9c1c-075032a13a1a")

let test_hash_should_not () =
  Alcotest.(check (float 0.00))
    "should" 0.56
    (Vexilla.Hash.hash_instance_id ~seed:0.22
       "b7e91cc5-ec76-4ec3-9c1c-075032a13a1a")

let () =
  let open Alcotest in
  run "Hash"
    [
      ( "hash",
        [
          test_case "should" `Quick test_hash_should;
          test_case "should not" `Quick test_hash_should_not;
        ] );
    ]

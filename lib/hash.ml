let hash_string_instance_id ~seed instance_id =
  let bytes = Bytes.of_string instance_id in
  let total =
    Bytes.fold_left
      (fun acc byte -> Float.(add acc @@ of_int @@ Char.code byte))
      0.0 bytes
  in
  let base = total *. seed *. 42.0 in
  let base_int = Int64.of_float base in
  Int64.rem base_int 100L

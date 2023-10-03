type t = [ `Invalid_manifest_version of string ]

let to_string = function
  | `Invalid_manifest_version version ->
      Printf.sprintf "Invalid manifest version: %s" version

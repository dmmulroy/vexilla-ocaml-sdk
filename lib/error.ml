type t =
  [ `Invalid_manifest_version of string
  | `Flag_group_not_found
  | `Feature_not_found
  | `Environment_not_found ]

let to_string = function
  | `Invalid_manifest_version version ->
      Printf.sprintf "Invalid manifest version: %s" version
  | `Flag_group_not_found -> "Flag group not found."
  | `Feature_not_found -> "Feature not found."
  | `Environment_not_found -> "Environment not found."
  | #t -> .

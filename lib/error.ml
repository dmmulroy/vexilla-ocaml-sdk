type t = Invalid_manifest_version

let to_string = function
  | Invalid_manifest_version -> "Invalid_manifest_version"

let of_string = function
  | "Invalid_manifest_version" -> Ok Invalid_manifest_version
  | _ -> Error "Unknown error"

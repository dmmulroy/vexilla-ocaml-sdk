type group_name = string
type group_id = string
type manifest_group = { name : group_name; group_id : group_id }
type t = { version : string; groups : manifest_group list }

let empty = { version = "1.0"; groups = [] }

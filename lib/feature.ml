type id = string
type name = string
type toggle = { value : bool } [@@deriving yojson]
type gradual = { value : int; seed : float } [@@deriving yojson]

type selective = String of string list | Int of int list | Float of float list
[@@deriving yojson]

type value = String of string | Int of int | Float of float
[@@deriving yojson]

type kind = Toggle of toggle | Gradual of gradual | Value of value
[@@deriving yojson]

type t = {
  name : name;
  feature_id : string; (* TODO *)
  schedule_type : string; (* TODO *)
  schedule : string; (* TODO *)
  kind : kind;
}

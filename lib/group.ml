type name = string
type id = string
type meta = { version : string }

type t = {
  id : id;
  name : name;
  meta : meta;
  environments : (Environment.id, Environment.t) Hashtbl.t;
  features : (Feature.id, Feature.t) Hashtbl.t;
}
[@@deriving make]

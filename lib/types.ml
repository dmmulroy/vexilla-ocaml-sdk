module Schedule = struct
  type kind = Daily | None | Start_end
  type timezone = Utc | Other of string

  type t = {
    start : int64 option;
    end_ : int64 option;
    timezone : timezone;
    kind : kind;
    start_time : int64;
    end_time : int64;
  }
end

module Feature = struct
  type id = string
  type name = string
  type attributes = { id : id; name : name; schedule : Schedule.t }
  type toggle = { attributes : attributes; value : bool }
  type gradual = { attributes : attributes; value : float; seed : float }

  type selective_value =
    | String_list of string list
    | Int_list of int list
    | Float_list of float list

  type selective = { attributes : attributes; value : selective_value }
  type scalar_value = String of string | Int of int | Float of float
  type value = { attributes : attributes; value : scalar_value }

  type t =
    | Toggle of toggle
    | Gradual of gradual
    | Selective of selective
    | Value of value

  let attributes = function
    | Toggle t -> t.attributes
    | Gradual g -> g.attributes
    | Selective s -> s.attributes
    | Value v -> v.attributes
end

module Environment = struct
  type name = string
  type id = string

  type default_features = {
    toggle : Feature.toggle;
    gradual : Feature.gradual;
    selective : Feature.selective;
    value : Feature.value;
  }

  type feature_key = [ `Id of Feature.id | `Name of Feature.name ]

  type t = {
    name : name;
    id : id;
    default_features : default_features;
    features : (feature_key, Feature.t) Hashtbl.t;
  }
end

module Group = struct
  type name = string
  type id = string
  type meta = { version : string }
  type group_id_or_name = Id of id | Name of name

  type t = {
    id : id;
    name : name;
    meta : meta;
    environments : (Environment.id, Environment.t) Hashtbl.t;
    features : (Feature.id, Feature.t) Hashtbl.t;
  }
  [@@deriving make]
end

module Manifest = struct
  type group_name = Group.name
  type group_id = Group.id
  type manifest_group = { name : group_name; id : group_id }
  type t = { version : string; groups : manifest_group list }

  let latest_manifest_version = "1.0"
  let empty = { version = latest_manifest_version; groups = [] }
end

module type S = sig
  type key
  type value
  type t

  val find : key:key -> t -> value option
  val has : key:key -> t -> bool
  val make : ?size:int -> unit -> t
  val remove : key:key -> t -> t
  val set : key:key -> value:value -> t -> t
end

module Base = struct
  module type S = sig
    type key
    type value
  end
end

module By_id_or_name = struct
  module type S = sig
    type id
    type name
  end
end

module Make (M : Base.S) : S with type key = M.key and type value = M.value =
struct
  type key = M.key
  type value = M.value
  type t = (key, value) Hashtbl.t

  let find ~key t = Hashtbl.find_opt t key
  let has ~key t = Hashtbl.mem t key
  let make ?(size = 10) () = Hashtbl.create size

  let remove ~key t =
    let () = Hashtbl.remove t key in
    t

  let set ~key ~value t =
    let () = Hashtbl.replace t key value in
    t
end

module Make_by_id_or_name (M : By_id_or_name.S) :
  S with type key = [ `Id of M.id | `Name of M.name ] and type value = M.id =
struct
  type key = [ `Id of M.id | `Name of M.name ]
  type value = M.id
  type t = (key, value) Hashtbl.t

  let find ~key t = Hashtbl.find_opt t key
  let has ~key t = Hashtbl.mem t key
  let make ?(size = 10) () = Hashtbl.create size

  let remove ~key t =
    let () = Hashtbl.remove t key in
    t

  let set ~key ~value t =
    let () = Hashtbl.replace t key value in
    t
end

module Group_lookup_table = Make_by_id_or_name (Types.Group)
module Feature_lookup_table = Make_by_id_or_name (Types.Feature)
module Environment_lookup_table = Make_by_id_or_name (Types.Environment)

module Composite_feature_lookup_table = Make (struct
  type key = Types.Group.id
  type value = Feature_lookup_table.t
end)

module Composite_environment_lookup_table = Make (struct
  type key = Types.Group.id
  type value = Environment_lookup_table.t
end)
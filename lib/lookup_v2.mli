module type S = sig 
  type t
  type key 
  type value

  val find : key:key -> t -> value option
  val has : key:key -> t -> bool
  val make : ?size:int -> unit -> t
  val remove : key:key -> t -> t
  val set : key:key -> value:value -> t -> t

end

module Base : sig 
  module type S = sig
    type key
    type value
  end
end

module By_id_or_name : sig
  module type S = sig
    type id
    type name
  end
end

module Make (M : Base.S) : S with type key = M.key and type value = M.value 

module Make_by_id_or_name  (M : By_id_or_name.S) : S with type key = [`Id of M.id | `Name of M.name] and type value = M.id

(* module Group_lookup_table = Make_by_id_or_name (Types.Group) *)
module Group_lookup_table : S with type key = [`Id of Types.Group.id | `Name of Types.Group.name] and type value = Types.Group.id
module Environment_lookup_table : S with type key = [`Id of Types.Environment.id | `Name of Types.Environment.name] and type value = Types.Environment.id

module Feature_lookup_table : S with type key = [`Id of Types.Feature.id | `Name of Types.Feature.name] and type value = Types.Feature.id

module Composite_environment_lookup_table : S with type key = Types.Group.id and type value = Environment_lookup_table.t
module Composite_feature_lookup_table : S with type key = Types.Group.id and type value = Feature_lookup_table.t

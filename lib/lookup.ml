module Table = struct
  type ('id, 'name) key = [ `Name of 'name | `Id of 'id ]
  type ('id, 'name) t = (('id, 'name) key, 'id) Hashtbl.t

  let add tbl k v = Hashtbl.add tbl k v
  let add_by_id tbl id = Hashtbl.add tbl (`Id id) id
  let add_by_name tbl name id = Hashtbl.add tbl (`Name name) id

  let add_list tbl lst =
    List.iter
      (fun (id, name) ->
        add tbl (`Name name) id;
        add tbl (`Id id) id)
      lst

  let find tbl k = Hashtbl.find_opt tbl k
  let make ?(size = 10) () = Hashtbl.create size
  let mem tbl key = Hashtbl.mem tbl key
  let remove tbl k = Hashtbl.remove tbl k
  let replace tbl k v = Hashtbl.replace tbl k v
end

module Composite_table = struct
  type ('composite_id, 'entity_id, 'entity_name) t =
    ('composite_id, ('entity_id, 'entity_name) Table.t) Hashtbl.t

  let add tbl id entity = Hashtbl.add tbl id entity
  let find tbl id = Hashtbl.find_opt tbl id
  let make ?(size = 10) () = Hashtbl.create size
  let mem tbl key = Hashtbl.mem tbl key
  let remove tbl id = Hashtbl.remove tbl id
  let replace tbl k v = Hashtbl.replace tbl k v
end

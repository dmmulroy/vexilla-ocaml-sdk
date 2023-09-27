type group_lookup_table =
  ([ `Name of Group.name | `Id of Group.id ], Group.id) Hashtbl.t

type environment_lookup_table =
  ( [ `Name of Environment.name | `Id of Environment.id ],
    Environment.id )
  Hashtbl.t

type feature_lookup_table =
  ([ `Name of Feature.name | `Id of Feature.id ], Feature.id) Hashtbl.t

type 'a group_entity_lookup_table = (Group.id, 'a) Hashtbl.t

type t = {
  environment : string;
  base_url : Uri.t;
  instance_id : string;
  show_logs : bool;
  manifest : Manifest.t;
  flag_groups : (Group.id, Group.t) Hashtbl.t;
  group_lookup_table : group_lookup_table;
  environment_lookup_table : environment_lookup_table group_entity_lookup_table;
  feature_lookup_table : feature_lookup_table group_entity_lookup_table;
}

let make ?(show_logs = false) ~environment ~base_url ~instance_id () =
  {
    environment;
    base_url;
    instance_id;
    show_logs;
    manifest = Manifest.empty;
    flag_groups = Hashtbl.create 10;
    group_lookup_table = Hashtbl.create 10;
    environment_lookup_table = Hashtbl.create 10;
    feature_lookup_table = Hashtbl.create 10;
  }

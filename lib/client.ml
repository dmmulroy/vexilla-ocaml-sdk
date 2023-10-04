type environment_lookup_table =
  ( Types.Group.id,
    Types.Environment.id,
    Types.Environment.name )
  Lookup.Composite_table.t

type feature_lookup_table =
  ( Types.Group.id,
    Types.Feature.id,
    Types.Feature.name )
  Lookup.Composite_table.t

type t = {
  environment : string;
  base_url : Uri.t;
  instance_id : string;
  show_logs : bool;
  manifest : Types.Manifest.t;
  flag_groups : (Types.Group.id, Types.Group.t) Hashtbl.t;
  group_lookup_table : (Types.Group.id, Types.Group.name) Lookup.Table.t;
  environment_lookup_table : environment_lookup_table;
  feature_lookup_table : feature_lookup_table;
}

let make ?(show_logs = false) ~environment ~base_url ~instance_id () =
  {
    environment;
    base_url;
    instance_id;
    show_logs;
    manifest = Types.Manifest.empty;
    flag_groups = Hashtbl.create 10;
    group_lookup_table = Lookup.Table.make ();
    environment_lookup_table = Lookup.Composite_table.make ();
    feature_lookup_table = Lookup.Composite_table.make ();
  }

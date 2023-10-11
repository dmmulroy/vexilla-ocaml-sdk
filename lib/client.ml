type t = {
  environment : string;
  base_url : Uri.t;
  instance_id : string;
  show_logs : bool;
  manifest : Types.Manifest.t;
  flag_groups : (Types.Group.id, Types.Group.t) Hashtbl.t;
  group_table : Lookup.Group_table.t;
  composite_environment_table : Lookup.Composite_environment_table.t;
  composite_feature_table : Lookup.Composite_feature_table.t;
}

let make ?(show_logs = false) ~environment ~base_url ~instance_id () =
  {
    environment;
    base_url;
    instance_id;
    show_logs;
    manifest = Types.Manifest.empty;
    flag_groups = Hashtbl.create 10;
    group_table = Lookup.Group_table.make ();
    composite_environment_table = Lookup.Composite_environment_table.make ();
    composite_feature_table = Lookup.Composite_feature_table.make ();
  }

type environment_lookup_table =
  (Group.id, Environment.id, Environment.name) Lookup.Composite_table.t

type feature_lookup_table =
  (Group.id, Feature.id, Feature.name) Lookup.Composite_table.t

type t = {
  environment : string;
  base_url : Uri.t;
  instance_id : string;
  show_logs : bool;
  manifest : Manifest.t;
  flag_groups : (Group.id, Group.t) Hashtbl.t;
  group_lookup_table : (Group.id, Group.name) Lookup.Table.t;
  environment_lookup_table : environment_lookup_table;
  feature_lookup_table : feature_lookup_table;
}

let make ?(show_logs = false) ~environment ~base_url ~instance_id () =
  {
    environment;
    base_url;
    instance_id;
    show_logs;
    manifest = Manifest.empty;
    flag_groups = Hashtbl.create 10;
    group_lookup_table = Lookup.Table.make ();
    environment_lookup_table = Lookup.Composite_table.make ();
    feature_lookup_table = Lookup.Composite_table.make ();
  }

let set_manifest t (manifest : Manifest.t) =
  let group_lookup_table =
    Lookup.Table.make ~size:(List.length manifest.groups) ()
  in
  manifest.groups
  |> List.map (fun (group : Manifest.manifest_group) -> (group.id, group.name))
  |> Lookup.Table.add_list group_lookup_table;
  { t with manifest; group_lookup_table }

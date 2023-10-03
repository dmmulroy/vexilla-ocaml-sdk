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

(* let set_manifest client (manifest : Manifest.t) =
   if manifest.version <> Manifest.latest_manifest_version then
     Error (`Invalid_manifest_version manifest.version)
   else
     let group_lookup_table =
       Lookup.Table.make ~size:(List.length manifest.groups) ()
     in
     manifest.groups
     |> List.map (fun (group : Manifest.manifest_group) ->
            (group.id, group.name))
     |> Lookup.Table.add_list group_lookup_table;
     Ok { client with manifest; group_lookup_table } *)

(* let latest_manifest_version = "1.0"
   let empty = { version = latest_manifest_version; groups = [] } *)

(* let get ~(base_url : Uri.t) ~(fetch_hook : (t, Error.t) Fetch.hook) : t Lwt.t =
   let* result = Uri.with_path base_url "manifest.json" |> fetch_hook in
   match result with
   | Ok manifest -> Lwt.return manifest
   | Error err ->
       Fmt.pr "Error: failed to fetch manifest: %s\n%!" (Error.to_string err);
       Lwt.return empty *)

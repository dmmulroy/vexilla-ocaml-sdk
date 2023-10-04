open Syntax
open Let

let latest_manifest_version = "1.0"

let empty : Types.Manifest.t =
  { version = latest_manifest_version; groups = [] }

let set_manifest ~(client : Client.t) (manifest : Types.Manifest.t) =
  if manifest.version <> latest_manifest_version then
    Error (`Invalid_manifest_version manifest.version)
  else
    let group_lookup_table =
      Lookup.Table.make ~size:(List.length manifest.groups) ()
    in
    manifest.groups
    |> List.map (fun (group : Types.Manifest.manifest_group) ->
           (group.id, group.name))
    |> Lookup.Table.add_list group_lookup_table;
    Ok { client with manifest; group_lookup_table }

let get ~base_url ~fetch_hook =
  let* result = Uri.with_path base_url "manifest.json" |> fetch_hook in
  match result with
  | Ok manifest -> Lwt.return manifest
  | Error err ->
      Fmt.pr "Error: failed to fetch manifest: %s\n%!" (Error.to_string err);
      Lwt.return empty

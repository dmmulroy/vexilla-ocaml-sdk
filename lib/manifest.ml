[@@@ocaml.warning "-32"]

open Syntax
open Let

type group_name = string
type group_id = string
type manifest_group = { name : group_name; id : group_id }
type t = { version : string; groups : manifest_group list }

let latest_manifest_version = "1.0"
let empty = { version = latest_manifest_version; groups = [] }
(* async setManifest(manifest: VexillaManifest) {
     this.manifest = manifest;
     this.groupLookupTable = createGroupLookupTable(manifest.groups);

     const currentVersion = this.manifest.version
       ? parseInt(this.manifest.version.replace("v", ""))
       : 0;

     if (currentVersion !== LATEST_MANIFEST_VERSION) {
       throw new Error(
         `Manifest version mismatch. Current: ${currentVersion} - Required: ${LATEST_MANIFEST_VERSION}. You must either use an appropriate client or you must update your schema.`
       );
     }
   } *)

let get ~(base_url : Uri.t) ~(fetch_hook : (t, Error.t) Fetch.hook) : t Lwt.t =
  let* result = Uri.with_path base_url "manifest.json" |> fetch_hook in
  match result with
  | Ok manifest -> Lwt.return manifest
  | Error err ->
      Fmt.pr "Error: failed to fetch manifest: %s\n%!" (Error.to_string err);
      Lwt.return empty

(* let set (manifest : t) : (t, Error.t) Lwt_result.t =
   let group_lookup = Hashtbl.create @@ List.length manifest.groups in
   manifest.groups
   |> List.iter (fun { group_id; group_name } ->
          [ (group_name, group_id); (group_id, group_id) ]
          |> List.to_seq
          |> Hashtbl.add_seq group_lookup);
   Lwt.return_ok manifest *)

[@@@ocaml.warning "-32"]

open Syntax
open Let

type group_name = string
type group_id = string
type manifest_group = { name : group_name; id : group_id }
type t = { version : string; groups : manifest_group list }

let latest_manifest_version = "1.0"
let empty = { version = latest_manifest_version; groups = [] }

let get ~(base_url : Uri.t) ~(fetch_hook : (t, Error.t) Fetch.hook) : t Lwt.t =
  let* result = Uri.with_path base_url "manifest.json" |> fetch_hook in
  match result with
  | Ok manifest -> Lwt.return manifest
  | Error err ->
      Fmt.pr "Error: failed to fetch manifest: %s\n%!" (Error.to_string err);
      Lwt.return empty

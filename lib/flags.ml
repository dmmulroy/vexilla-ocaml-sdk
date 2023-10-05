[@@@ocaml.warning "-26-27-33"]

open Str
open Syntax
open Let

type t

let json_regex = Str.regexp ".json"

let get ~(client : Client.t) ~fetch_hook group_id_or_name =
  let key =
    match group_id_or_name with
    | Types.Group.Id id -> `Id id
    | Name name -> `Name (Str.global_replace json_regex "" name)
  in
  let| group_id =
    key
    |> Lookup.Table.find client.group_table
    |> Option.to_result ~none:`Flag_group_not_found
  in
  let+ result = Uri.with_path client.base_url group_id |> fetch_hook in
  Lwt.return_ok result

let set ~(client : Client.t) ~group group_id_or_name =
  let key =
    match group_id_or_name with
    | Types.Group.Id id -> `Id id
    | Name name -> `Name (Str.global_replace json_regex "" name)
  in
  let@ group_id =
    key
    |> Lookup.Table.find client.group_table
    |> Option.to_result ~none:`Flag_group_not_found
  in
  Hashtbl.add client.flag_groups group_id group;
  let environment_table :
      (Types.Environment.id, Types.Environment.name) Lookup.Table.t =
    Lookup.Composite_table.find client.environment_table group_id
    |> Option.value ~default:(Lookup.Table.make ())
  in
  let () =
    List.iter
      Types.Environment.(
        fun environment ->
          Lookup.Table.replace environment_table (`Id environment.id)
            environment.id;
          Lookup.Table.replace environment_table (`Name environment.name)
            environment.id)
      (group.environments |> Hashtbl.to_seq_values |> List.of_seq)
  in
  Lookup.Composite_table.replace client.environment_table group_id
    environment_table;
  let feature_table :
      (Types.Feature.id, Types.Feature.name) Lookup.Table.t =
    Lookup.Composite_table.find client.feature_table group_id
    |> Option.value ~default:(Lookup.Table.make ())
  in
  let () =
    List.iter
      (fun (feature : Types.Feature.t) ->
        let attributes =
          match feature with
          | Toggle { attributes; _ } -> attributes
          | Gradual { attributes; _ } -> attributes
          | Selective { attributes; _ } -> attributes
          | Value { attributes; _ } -> attributes
        in
        Lookup.Table.replace feature_table (`Id attributes.id)
          attributes.id;
        Lookup.Table.replace feature_table (`Name attributes.name)
          attributes.id)
      (group.features |> Hashtbl.to_seq_values |> List.of_seq)
  in
  Ok client

open Syntax
open Let

type t = {
  environment : [ `Id of string | `Name of string ];
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

let get_real_group_id ~client group_id_or_name =
  client.group_table
  |> Lookup.Group_table.find ~key:group_id_or_name
  |> Option.to_result ~none:`Flag_group_not_found

let get_real_feature_id ~client group_id feature_id_or_name =
  let ( >>= ) = Result.bind in
  client.composite_feature_table
  |> Lookup.Composite_feature_table.find ~key:group_id
  |> Option.to_result ~none:`Flag_group_not_found
  >>= fun feature_table ->
  Lookup.Feature_table.find ~key:feature_id_or_name feature_table
  |> Option.to_result ~none:`Feature_not_found

let get_real_environment_id ~client group_id =
  let ( >>= ) = Result.bind in
  client.composite_environment_table
  |> Lookup.Composite_environment_table.find ~key:group_id
  |> Option.to_result ~none:`Flag_group_not_found
  >>= fun environment_table ->
  Lookup.Environment_table.find ~key:client.environment environment_table
  |> Option.to_result ~none:`Environment_not_found

let get_real_ids ~client group_id_or_name feature_name_or_id =
  let@ group_id = get_real_group_id ~client group_id_or_name in
  let@ feature_id = get_real_feature_id ~client group_id feature_name_or_id in
  let@ environment_id = get_real_environment_id ~client group_id in
  Ok (group_id, feature_id, environment_id)

let get_feature ~client group_id_or_name feature_name_or_id =
  let@ group_id, feature_id, environment_id =
    get_real_ids ~client group_id_or_name feature_name_or_id
  in
  let@ group =
    Hashtbl.find_opt client.flag_groups group_id
    |> Option.to_result ~none:`Flag_group_not_found
  in
  let@ environment =
    Hashtbl.find_opt group.environments environment_id
    |> Option.to_result ~none:`Environment_not_found
  in
  Hashtbl.find_opt environment.features (`Id feature_id)
  |> Option.to_result ~none:`Feature_not_found

let should ~client ?instance_id group_id_or_name feature_name_or_id =
  let open Types.Feature in
  let@ feature = get_feature ~client group_id_or_name feature_name_or_id in
  match feature with
  | Toggle toggle -> Ok toggle.value
  | Gradual gradual ->
      let hash = Hash.hash_instance_id ~seed:gradual.seed client.instance_id in
      Ok (hash <= gradual.value)
  | Selective selective -> (
      let instance_id' =
        Option.value instance_id ~default:(`String client.instance_id)
      in
      (* Todo: Use Option.is_some *)
      match (selective.value, instance_id') with
      | String_list strings, `String id ->
          strings
          |> List.find_opt (fun str -> String.equal str id)
          |> Option.fold ~none:false ~some:(fun _ -> true)
          |> Result.ok
      | Int_list ints, `Int id ->
          ints
          |> List.find_opt (fun str -> Int.equal str id)
          |> Option.fold ~none:false ~some:(fun _ -> true)
          |> Result.ok
      | Float_list floats, `Float id ->
          floats
          |> List.find_opt (fun str -> Float.equal str id)
          |> Option.fold ~none:false ~some:(fun _ -> true)
          |> Result.ok
      | _ -> Result.error `Invalid_instance_id)
  | Value _ -> Error (`Msg "TODO: handle this error")

open Alcotest
open Vexilla

let test_no_schedule () =
  let zero = Ptime.of_float_s 0.0 |> Option.get in
  let schedule =
    Types.Schedule.make ~start:zero ~end':zero ~timezone:Utc ~time_type:None
      ~start_time:zero ~end_time:zero
  in
  let expected = true in
  let actual =
    Schedule.is_schedule_active ~schedule ~schedule_type:Empty
    |> Result.value ~default:false
  in
  check bool "no schedule" expected actual

let () =
  run "Schedule"
    [ ("schedule", [ test_case "no schedule" `Quick test_no_schedule ]) ]

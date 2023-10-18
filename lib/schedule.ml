[@@@ocaml.warning "-27"]

open Syntax
open Let

let is_schedule_active_with_now ~schedule ~schedule_type now =
  let open Types.Schedule in
  match schedule_type with
  | Empty -> Ok true
  | Environment | Global -> (
      (* Convert to/from a date to zero out the time to the beginning of the day *)
      let@ start_of_start_date =
        schedule.start |> Ptime.to_date |> Ptime.of_date
        |> Option.to_result ~none:(`Invalid_date schedule.start)
      in
      let@ end_of_end_date =
        schedule.end' |> Ptime.to_date |> fun date ->
        Ptime.of_date_time (date, ((23, 59, 59), 0))
        |> Option.to_result ~none:(`Invalid_date schedule.end')
      in
      if
        Ptime.is_earlier ~than:start_of_start_date now
        || Ptime.is_later ~than:end_of_end_date now
      then Ok false
      else
        let _, start_time = Ptime.to_date_time schedule.start in
        let _, end_time = Ptime.to_date_time schedule.end' in
        match schedule.time_type with
        | None -> Ok true
        | Start_end ->
            let@ start =
              Ptime.(of_date_time (to_date start_of_start_date, start_time))
              |> Option.to_result ~none:(`Invalid_date schedule.start)
            in
            let@ end' =
              Ptime.(of_date_time (to_date end_of_end_date, end_time))
              |> Option.to_result ~none:(`Invalid_date schedule.end')
            in
            let is_after_start_date_time = Ptime.is_later ~than:start now in
            let is_before_end_date_time = Ptime.is_earlier ~than:end' now in
            Ok (is_after_start_date_time && is_before_end_date_time)
        | Daily ->
            let now = Ptime_clock.now () in
            let@ today_zero_timestamp =
              Ptime.to_date now |> Ptime.of_date
              |> Option.to_result ~none:(`Invalid_date now)
            in
            let@ zeroed_start_timestamp =
              Ptime.(of_date_time (to_date epoch, start_time))
              |> Option.to_result ~none:(`Invalid_date Ptime.epoch)
            in
            let@ zeroed_end_timestamp =
              Ptime.(of_date_time (to_date epoch, end_time))
              |> Option.to_result ~none:(`Invalid_date Ptime.epoch)
            in
            let zeroed_end_span = Ptime.to_span zeroed_end_timestamp in
            let day_span = Ptime.Span.of_int_s 86400 in
            let zeroed_end_timestamp_plus_day =
              Ptime.Span.add zeroed_end_span day_span
              |> Ptime.of_span |> Option.get
            in
            let start_timestamp =
              Ptime.(
                Span.add
                  (to_span today_zero_timestamp)
                  (to_span zeroed_start_timestamp)
                |> of_span)
              |> Option.get
            in
            let end_timestamp =
              if
                Ptime.is_later ~than:zeroed_end_timestamp zeroed_start_timestamp
                || Ptime.to_float_s zeroed_start_timestamp < 0.0
              then
                Ptime.(
                  Span.add
                    (to_span today_zero_timestamp)
                    (to_span zeroed_end_timestamp_plus_day)
                  |> of_span)
                |> Option.get
              else
                Ptime.(
                  Span.add
                    (to_span today_zero_timestamp)
                    (to_span zeroed_end_timestamp)
                  |> of_span)
                |> Option.get
            in
            Ok
              Ptime.(
                to_float_s now > to_float_s start_timestamp
                && to_float_s now < to_float_s end_timestamp))

let is_schedule_active ~schedule ~schedule_type =
  is_schedule_active_with_now ~schedule ~schedule_type (Ptime_clock.now ())

let is_schedule_feature_active (feature : Types.Feature.t) =
  let attributes = Types.Feature.attributes feature in
  is_schedule_active ~schedule:attributes.schedule
    ~schedule_type:attributes.schedule_type

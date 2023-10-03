type kind = Daily | None | Start_end
type timezone = Utc | Other of string

type t = {
  start : int64 option;
  end_ : int64 option;
  timezone : timezone;
  kind : kind;
  start_time : int64;
  end_time : int64;
}

type id = string
type name = string
type attributes = { id : id; name : name; schedule : Schedule.t }
type toggle = { attributes : attributes; value : bool }
type gradual = { attributes : attributes; value : int; seed : float }

type selective_value =
  | String_list of string list
  | Int_list of int list
  | Float_list of float list

type selective = { attributes : attributes; value : selective_value }
type scalar_value = String of string | Int of int | Float of float
type value = { attributes : attributes; value : scalar_value }

type t =
  | Toggle of toggle
  | Gradual of gradual
  | Selective of selective
  | Value of value

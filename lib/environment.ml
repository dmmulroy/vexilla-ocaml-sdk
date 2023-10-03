type name = string
type id = string

type default_features = {
  toggle : Feature.toggle;
  gradual : Feature.gradual;
  selective : Feature.selective;
  value : Feature.value;
}

type feature_key = Id of Feature.id | Name of Feature.name

type t = {
  name : name;
  id : id;
  default_features : default_features;
  features : (feature_key, Feature.t) Hashtbl.t;
}

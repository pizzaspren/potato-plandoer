extends Node
class_name PickupDataProvider

static var _pickups_file:String = "res://data/selectable-pickups.json"
var _pickups_raw:Array
var pickups_by_id:Dictionary
var pickup_mapping:Dictionary[int, int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parsed_data = JSON.parse_string(FileAccess.get_file_as_string(_pickups_file))
	_pickups_raw = parsed_data["pickups"]
	for pickup in _pickups_raw:
		pickups_by_id[int(pickup["id"])] = pickup

func add_selectable_id_mapping(idx: int, pickup_id: int):
	pickup_mapping[idx] = pickup_id

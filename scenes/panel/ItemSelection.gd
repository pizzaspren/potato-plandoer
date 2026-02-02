extends ItemList

@export var _pickups_file:String = "res://data/selectable-pickups.json"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while item_count:
		remove_item(0)
	if item_count == 0:  # Selections don't exist
		if OS.has_feature("editor"):
			_create_selection_list()
		else:
			printerr("No icons available")


func _create_selection_list() -> void:
	var _last_section: String = ""
	for pickup in _read_json_pickups():
		var _icon: String = ""
		var _type: String = pickup["type"]
		
		match _type:
			"skill": _icon = "res://assets/icons/pickups/ability/%s.png" % pickup["id"]
			"resource": _icon = "res://assets/icons/pickups/resource/%s.png" % pickup["id"]
			"shard": _icon = "res://assets/icons/pickups/Shard.png"
			"teleporter": _icon = "res://assets/icons/Teleporter.png"
			"custom":
				match pickup["id"]:
					"CleanWater": _icon = "res://assets/icons/pickups/CleanWater.png"
		if not ResourceLoader.exists(_icon):
			_icon = "res://assets/icons/Unknown.png"
		add_item(pickup["text"], load(_icon))

func _read_json_pickups() -> Array:
	var data = JSON.parse_string(FileAccess.get_file_as_string(_pickups_file))
	return data["pickups"]

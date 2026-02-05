extends ItemList

enum CustomIconIds {
	CLEAN_WATER = 6
}

var _pickup_data_provider:PickupDataProvider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_pickup_data_provider = get_tree().get_first_node_in_group("PickupDataProvider") as PickupDataProvider
	_create_selection_list()


func _create_selection_list() -> void:
	var _last_section: String = ""
	for pickup in _pickup_data_provider.pickups_by_id.values():
		var _icon: String = ""
		var _type: String = pickup["type"]
		
		match _type:
			"skill": _icon = "res://assets/icons/pickups/ability/%s.png" % pickup["iconName"]
			"resource": _icon = "res://assets/icons/pickups/resource/%s.png" % pickup["iconName"]
			"shard": _icon = "res://assets/icons/pickups/Shard.png"
			"teleporter": _icon = "res://assets/icons/Teleporter.png"
			"custom":
				match int(pickup["id"]):
					CustomIconIds.CLEAN_WATER: _icon = "res://assets/icons/pickups/CleanWater.png"
		if not ResourceLoader.exists(_icon):
			_icon = "res://assets/icons/Unknown.png"
		var idx = add_item(pickup["text"], load(_icon))
		# Future-proof the order of selectables changing around between releases
		_pickup_data_provider.add_selectable_id_mapping(idx, pickup["id"])

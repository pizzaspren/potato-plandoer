extends VBoxContainer
class_name PickupListContainer

# Emit to individual children
signal set_pickup_state(pickup_id:int, state_id:int)

@onready var selectable_pickup_scene:PackedScene = preload("res://scenes/pickup_panel/SelectablePickup.tscn")


enum CustomIconIds {
	CLEAN_WATER = 6
}

var _pickup_data_provider:PickupDataProvider
var _section_separators:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_pickup_data_provider = get_tree().get_first_node_in_group("PickupDataProvider") as PickupDataProvider
	_create_selection_list()


func _create_selection_list() -> void:
	var _last_section: String = ""
	for pickup in _pickup_data_provider.pickups_by_id.values():
		var _icon: String = ""
		var _type: String = pickup["type"]
		
		if _last_section != _type:
			_last_section = _type
			var section_label = Label.new()
			section_label.text = _type.to_upper()
			section_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			add_child(section_label)
			_section_separators += 1
		
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
		var idx = _add_item(pickup["text"], load(_icon), pickup["id"])
		# Future-proof the order of selectables changing around between releases
		_pickup_data_provider.add_selectable_id_mapping(idx, pickup["id"])
		
		
func _add_item(label:String, tex:Texture2D, pickup_id:int) -> int:
	var sp = selectable_pickup_scene.instantiate() as SelectablePickup
	sp.text = label
	sp.icon = tex
	sp.pickup_id = pickup_id
	sp.add_to_group("SelectablePickup")
	set_pickup_state.connect(sp.on_set_pickup_state)
	add_child(sp)
	return get_children().find(sp) - _section_separators


func get_selections() -> Dictionary[int, PanelPickupModel.PickupState]:
	var model:Dictionary[int, PanelPickupModel.PickupState] = {}
	var selectable_pickups = get_tree().get_nodes_in_group("SelectablePickup") as Array[SelectablePickup]
	for sp in selectable_pickups:
		if sp.state != PanelPickupModel.PickupState.SKIP:
			model[sp.pickup_id] = sp.state
	return model


func reset_selections() -> void:
	set_selected(PanelPickupModel.new())


func set_selected(selected_pickups:PanelPickupModel) -> void:
	for pickup in _pickup_data_provider.pickups_by_id:  # Iterate over all to reset states as well
		if pickup in selected_pickups.data:
			set_pickup_state.emit(pickup, selected_pickups.data.get(pickup))
		else:
			set_pickup_state.emit(pickup, 0)

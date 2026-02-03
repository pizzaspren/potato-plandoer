extends TextureButton
class_name PickupButton

var _panel : PickupPanel

@export var icon_size = 15.0
var _pos:Vector2 = Vector2(0.0, 0.0)
var _selected_pickups:PackedInt32Array = []
var _is_removing:bool = false


func _init(n: String = "Default", icon_resource: String = "", pos: Dictionary = {}) -> void:
	if not name:
		name = n
	if not _pos and pos:
		_pos = Vector2(pos["x"], pos["y"])
		# TextureButtons are anchored at top left because of Control inheritance
		position = Vector2(_pos[0] - icon_size / 3, _pos[1] + icon_size / 2)
		ignore_texture_size = true
		size = Vector2(icon_size, icon_size)
		scale = Vector2(1, -1)
		stretch_mode = TextureButton.STRETCH_SCALE
		texture_normal = load(icon_resource)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	if not _panel:
		_panel = get_tree().get_nodes_in_group("PanelGroup")[0]
	_panel.new_pickup.emit(name, _selected_pickups, _is_removing, _on_save_from_panel)


func _on_save_from_panel(pickup_name: String, selected_pickups: PackedInt32Array, is_removing: bool):
	if pickup_name != name:
		return  # Not for this node
	_selected_pickups = selected_pickups
	_is_removing = is_removing

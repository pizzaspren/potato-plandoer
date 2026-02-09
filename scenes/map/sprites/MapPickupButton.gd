extends TextureButton
class_name PickupButton

static var FADED_MODULATION:Color = Color(1, 1, 1, 0.4)
static var NORMAL_MODULATION:Color = Color.WHITE

var _panel:PickupPanel

@export var icon_size = 15.0
var _selected_pickups:PanelPickupModel = PanelPickupModel.new()

# Created anew every run
func _init(n: String, icon_resource: Texture2D, pos: Dictionary) -> void:
	name = n
	# TextureButtons are anchored at top left because of Control inheritance
	position = Vector2(pos["x"] - icon_size / 3, pos["y"] + icon_size / 2)
	ignore_texture_size = true
	size = Vector2(icon_size, icon_size)
	scale = Vector2(1, -1)
	stretch_mode = TextureButton.STRETCH_SCALE
	texture_normal = icon_resource
	
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	modulate = FADED_MODULATION


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	if not _panel:
		_panel = get_tree().get_first_node_in_group("PanelGroup")
	_panel.open_panel_for_location.emit(name, _selected_pickups, _on_save_from_panel)


func _on_save_from_panel(pickup_name: String, selected_pickups: PanelPickupModel):
	if pickup_name != name:
		return  # Not for this node
	_selected_pickups = selected_pickups
	
	if _selected_pickups.is_empty():
		modulate = FADED_MODULATION  # Fade out icon if it's empty
	else:
		modulate = NORMAL_MODULATION

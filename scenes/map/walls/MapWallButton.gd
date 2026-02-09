extends TextureButton
class_name WallButton

static var FADED_MODULATION:Color = Color(1, 1, 1, 0.2)
static var NORMAL_MODULATION:Color = Color.WHITE


@export var icon_size = 15.0


func _init(n: String, icon_resource: Texture2D, clickable_mask:BitMap, pos: Dictionary) -> void:
	name = n
	toggle_mode = true
	
	# TextureButtons are anchored at top left because of Control inheritance
	position = Vector2(pos["x"] - icon_size / 3, pos["y"] + icon_size / 2)
	ignore_texture_size = true
	size = Vector2(icon_size, icon_size)
	scale = Vector2(1, -1)
	stretch_mode = TextureButton.STRETCH_SCALE
	texture_normal = icon_resource
	texture_click_mask = clickable_mask
	
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	modulate = NORMAL_MODULATION


func _ready() -> void:
	toggled.connect(_on_toggle)


func _on_toggle(toggle_status:bool) -> void:
	if toggle_status:
		modulate = FADED_MODULATION  # Fade out if pressed
	else:
		modulate = NORMAL_MODULATION

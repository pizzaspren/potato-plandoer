extends VBoxContainer
class_name MetaTabManager

@onready var remove_from_map:CheckButton = %RemoveFromMap


func reset() -> void:
	remove_from_map.button_pressed = false


func set_from_model(model:PanelPickupModel) -> void:
	remove_from_map.button_pressed = model.removed


func update_model(model:PanelPickupModel) -> void:
	model.removed = remove_from_map.button_pressed

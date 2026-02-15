extends VBoxContainer
class_name MetaTabManager

@onready var pickup_exists:CheckButton = %PickupExists


func reset() -> void:
	pickup_exists.button_pressed = true


func set_from_model(model:PanelPickupModel) -> void:
	pickup_exists.button_pressed = !model.removed


func update_model(model:PanelPickupModel) -> void:
	model.removed = !pickup_exists.button_pressed

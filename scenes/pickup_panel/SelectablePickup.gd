extends Button
class_name SelectablePickup

@export var state_styles:Dictionary[PanelPickupModel.PickupState, StyleBox]

var pickup_id:int
var state:PanelPickupModel.PickupState = PanelPickupModel.PickupState.SKIP


func _on_pressed() -> void:
	set_state(state + 1)


func set_state(new_state:PanelPickupModel.PickupState):
	state = new_state % PanelPickupModel.PickupState.keys().size() as PanelPickupModel.PickupState  # Cycle through
	add_theme_stylebox_override("normal", state_styles[state])
	add_theme_stylebox_override("pressed", state_styles[state])
	add_theme_stylebox_override("hover", state_styles[state])
	

# Handles event coming from the selection panel on new pickup being loaded
func on_set_pickup_state(id: int, new_state:PanelPickupModel.PickupState) -> void:
	if id == pickup_id:
		set_state(new_state)

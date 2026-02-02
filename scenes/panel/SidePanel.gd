extends FoldableContainer


@onready var item_list:ItemList = %ItemList
@onready var remove_slider:CheckButton = %RemoveSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_user_signal("pickup_callback", [
		{"name": "pickup", "type": TYPE_STRING},
		{"name": "resource", "type": TYPE_DICTIONARY},
		{"name": "resource_removal", "type": TYPE_BOOL},
	])
	fold()


func _on_folding_changed(_expanded: bool) -> void:
	emit_signal("pickup_callback", title, {"id": "Launch", "amount": 1, "text": "Example"}, remove_slider.button_pressed)

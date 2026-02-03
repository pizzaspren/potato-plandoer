extends FoldableContainer
class_name PickupPanel

@warning_ignore("unused_signal")
signal new_pickup(pickup_name: String, selected_pickups: PackedInt32Array, is_removing: bool, save_callback: Callable)

@onready var item_list:ItemList = %ItemList
@onready var remove_slider:CheckButton = %RemoveSlider
@onready var button_reset:Button = %ButtonClear
@onready var button_save:Button = %ButtonOk

var _current_pickup_name:String
var _current_save_callback:Callable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fold()
	button_reset.pressed.connect(_on_reset_pickup)
	button_save.pressed.connect(_on_save_pickup)
	button_reset.disabled = true  # Don't allow saving until there's a pickup
	button_save.disabled = true  # Don't allow saving until there's a pickup
	remove_slider.disabled = true


func _on_new_pickup(pickup_name: String, selected_pickups: PackedInt32Array, is_removing: bool, save_callback: Callable) -> void:
	button_reset.disabled = false
	button_save.disabled = false
	remove_slider.disabled = false
	
	# TODO auto-save previous pickup?
	
	_current_pickup_name = pickup_name
	title = pickup_name.replace("_", ".").rstrip("123456789")  # Hint at the top
	item_list.deselect_all()  # Deselect everything
	item_list.get_v_scroll_bar().value = 0
	for sp:int in selected_pickups:  # Select only previously loaded
		item_list.select(sp, false)
	remove_slider.button_pressed = is_removing
	_current_save_callback = save_callback


func _on_reset_pickup() -> void:
	item_list.deselect_all()
	item_list.get_v_scroll_bar().value = 0  # Scroll to the top
	remove_slider.button_pressed = false


func _on_save_pickup() -> void:
	if not _current_save_callback:
		print("No pickup selected")
		return
	var selectedItems:PackedInt32Array = item_list.get_selected_items()
	var is_removing:bool = remove_slider.button_pressed
	_current_save_callback.call(_current_pickup_name, selectedItems, is_removing)

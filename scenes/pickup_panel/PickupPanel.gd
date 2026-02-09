extends FoldableContainer
class_name PickupPanel

@warning_ignore("unused_signal")
signal open_panel_for_location(pickup_name: String, selected_pickups: PanelPickupModel, save_callback: Callable)

@onready var scroll:ScrollContainer = %ScrollContainer
@onready var message_container:LineEdit = %CustomMessage
@onready var pickup_list_container:PickupListContainer = %PickupListContainer
@onready var button_reset:Button = %ButtonClear
@onready var button_save:Button = %ButtonOk

var _current_pickup_name:String
var _current_save_callback:Callable


func _ready() -> void:
	button_reset.pressed.connect(_on_reset_pickup)
	button_save.pressed.connect(_on_save_pickup)


func _on_open_panel_for_location(pickup_name: String, selected_pickups: PanelPickupModel, save_callback: Callable) -> void:
	visible = true  # Starts hidden
	expand()  # QoL?
	
	# auto-save previous pickup?
	
	_current_pickup_name = pickup_name
	title = pickup_name.replace("_", ".").rstrip("123456789")  # Hint at the top
	message_container.text = selected_pickups.message
	pickup_list_container.set_selected(selected_pickups)
	_current_save_callback = save_callback


func _on_reset_pickup() -> void:
	scroll.get_v_scroll_bar().value = 0
	message_container.text = ""
	pickup_list_container.reset_selections()


func _on_save_pickup() -> void:
	if not _current_save_callback:
		print("No pickup selected")
		return
	var panel_model = PanelPickupModel.new()
	panel_model.message = message_container.text
	panel_model.data = pickup_list_container.get_selections()
	_current_save_callback.call(_current_pickup_name, panel_model)

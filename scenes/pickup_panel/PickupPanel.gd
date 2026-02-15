extends FoldableContainer
class_name PickupPanel

@warning_ignore("unused_signal")
signal open_panel_for_location(pickup_name: String, model: PanelPickupModel, save_callback: Callable)

@onready var tab_container:TabContainer = %TabContainer
@onready var pickups_tab:PickupsTabManager = %Pickups
@onready var text_tab:TextTabManager = %Text
@onready var meta_tab:MetaTabManager = %Meta

@onready var button_reset:Button = %ButtonClear
@onready var button_save:Button = %ButtonOk

var _current_pickup_name:String
var _current_save_callback:Callable


func _ready() -> void:
	button_reset.pressed.connect(_on_reset_pickup)
	button_save.pressed.connect(_on_save_pickup)


func _on_open_panel_for_location(pickup_name: String, model: PanelPickupModel, save_callback: Callable) -> void:
	visible = true  # Starts hidden
	expand()  # QoL?
	tab_container.current_tab = 0  # QoL?
	
	# auto-save previous pickup?
	
	_current_pickup_name = pickup_name
	title = pickup_name.replace("_", ".").rstrip("123456789")  # Hint at the top
	
	pickups_tab.set_from_model(model)
	text_tab.set_from_model(model)
	meta_tab.set_from_model(model)
	
	_current_save_callback = save_callback


func _on_reset_pickup() -> void:
	pickups_tab.reset()
	text_tab.reset()
	meta_tab.reset()


func _on_save_pickup() -> void:
	if not _current_save_callback:
		print("No pickup selected")
		return
	var model = PanelPickupModel.new()
	pickups_tab.update_model(model)
	text_tab.update_model(model)
	meta_tab.update_model(model)
	_current_save_callback.call(_current_pickup_name, model)

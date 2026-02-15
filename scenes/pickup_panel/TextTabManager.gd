extends MarginContainer
class_name TextTabManager

@onready var message_container:LineEdit = %CustomMessage
@onready var message_duration:SpinBox = %DurationFrames
@onready var mute_pickups:CheckButton = %MuteEverythingElse


func reset() -> void:
	message_container.text = ""
	message_duration.value = 240
	mute_pickups.button_pressed = false


func set_from_model(model:PanelPickupModel) -> void:
	message_container.text = model.message
	message_duration.value = model.message_frames
	mute_pickups.button_pressed = model.mute_pickups


func update_model(model:PanelPickupModel) -> void:
	model.message = message_container.text
	model.message_frames = int(message_duration.value)
	model.mute_pickups = mute_pickups.button_pressed

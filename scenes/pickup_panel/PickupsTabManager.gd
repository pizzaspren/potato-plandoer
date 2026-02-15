extends MarginContainer
class_name PickupsTabManager


@onready var scroll:ScrollContainer = %PickupsScrollContainer
@onready var pickup_list_container:PickupListContainer = %PickupListContainer


func reset() -> void:
	scroll.get_v_scroll_bar().value = 0
	pickup_list_container.reset_selections()


func set_from_model(model:PanelPickupModel) -> void:
	pickup_list_container.set_selected(model)


func update_model(model:PanelPickupModel) -> void:
	model.data = pickup_list_container.get_selections()

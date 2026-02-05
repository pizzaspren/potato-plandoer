extends Node2D

@export var icon_provider:Resource
@export var icon_size = 15.0
static var _blacklisted_icons = [77, 78]  # Redundant race icons

var _pickup_location_provider:PickupLocationProvider


func _ready() -> void:
	_pickup_location_provider = get_tree().get_first_node_in_group("PickupLocationProvider") as PickupLocationProvider
	_create_icons()


func _create_icons() -> void:
	for location in _pickup_location_provider.locations_by_name.values():
		if _blacklisted_icons.has(int(location["icon"])) or location["label"].ends_with("Shop"):
			continue  # FIXME: Shops.
		for loc_pos in location["positions"]:
			var sprite = PickupButton.new(location["label"], icon_provider.icon_map[int(location["icon"])], loc_pos)
			add_child(sprite)
			sprite.set_owner(get_tree().get_edited_scene_root())
			sprite.add_to_group("PickupLocations")

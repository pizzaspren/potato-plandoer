extends Node2D

@export var icon_provider:Resource
@export var icon_size = 15.0

var _wall_location_provider:WallLocationProvider


func _ready() -> void:
	_wall_location_provider = get_tree().get_first_node_in_group("WallLocationProvider") as WallLocationProvider
	_create_icons()


func _create_icons() -> void:
	for wall in _wall_location_provider.walls_by_name.values():
		for wall_pos in wall["positions"]:
			var sprite = WallButton.new(wall["label"], icon_provider.icon_map[int(wall["icon"])], wall_pos)
			add_child(sprite)
			sprite.set_owner(get_tree().get_edited_scene_root())
			sprite.add_to_group("WallLocations")

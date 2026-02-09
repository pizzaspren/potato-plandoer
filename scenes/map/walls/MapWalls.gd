extends Node2D

@export var icon_provider:IconProvider
@export var icon_size = 15.0

var _wall_location_provider:WallLocationProvider


func _ready() -> void:
	_wall_location_provider = get_tree().get_first_node_in_group("WallLocationProvider") as WallLocationProvider
	_create_icons()


func _create_icons() -> void:
	for wall in _wall_location_provider.walls_by_name.values():
		for wall_pos in wall["positions"]:
			var icon = icon_provider.icon_map[int(wall["icon"])]
			var icon_bitmap = icon_provider.get_bitmap(int(wall["icon"]))
			var sprite = WallButton.new(wall["label"], icon, icon_bitmap, wall_pos)
			add_child(sprite)
			sprite.set_owner(get_tree().get_edited_scene_root())
			sprite.add_to_group("WallLocations")

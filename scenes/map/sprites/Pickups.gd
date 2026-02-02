@tool
extends Node2D

@export var loc_data_file := String("res://data/loc_data.csv")
@export var map_icons_json := String("res://data/map-icons.json")  # TODO: Fetch

@export var icon_size = 15.0
static var _blacklisted_icons = [77, 78]  # Redundant race icons


func _ready() -> void:
	if get_child_count() == 0:  # Icons don't exist
		if OS.has_feature("editor"):
			_create_icons()
		else:
			printerr("No icons available")


func _create_icons() -> void:
	var GetIconResource = load("res://scripts/IconManager/GetIconResource.gd")
	var icon_data = _read_json_icons()
	for icon in icon_data:
		if _blacklisted_icons.has(icon[1]):
			continue
		var sprite = PickupButton.new(icon[0], GetIconResource.get_icon_resource(icon[1]), icon[2])
		add_child(sprite)
		sprite.set_owner(get_tree().get_edited_scene_root())


func _read_json_icons() -> Array:
	# TODO: Read from api
	var data = JSON.parse_string(FileAccess.get_file_as_string(map_icons_json))
	var trimmed_data = []
	for idata:Dictionary in data["mapIcons"]:
		for valid_position in idata["positions"]:
			trimmed_data.append([
				idata["label"],
				int(idata["icon"]),
				valid_position
			])
	return trimmed_data

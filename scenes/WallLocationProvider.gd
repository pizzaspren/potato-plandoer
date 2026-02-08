extends Node
class_name WallLocationProvider


static var _locations_file:String = "res://data/map-walls.json"  # TODO: Fetch from API???
var _walls_raw:Array
var walls_by_name:Dictionary


func _ready() -> void:
	var data = JSON.parse_string(FileAccess.get_file_as_string(_locations_file))  # TODO: Fetch from API???
	_walls_raw = data["mapWalls"]
	for wall in _walls_raw:
		walls_by_name[wall["label"]] = wall


func wall_as_v4(wall_name:String) -> String:
	var wall_data = walls_by_name.get(wall_name.replace("_", "."))
	var wall_uberstate = wall_data["visibleIfAny"][0]
	
	var ubergroup = int(wall_uberstate["uberIdentifier"][0])
	var uberid = int(wall_uberstate["uberIdentifier"][1])
	var value = roundi(wall_uberstate["value"])  # Some uberstates are returned as 0.5
	
	if value == 1:
		return "3|0|8|%d|%d|bool|true" % [ubergroup, uberid]
	return "3|0|8|%d|%d|int|%d" % [ubergroup, uberid, value]


func wall_as_v5(wall_name:String) -> String:
	var wall_data = walls_by_name.get(wall_name)
	var location_uberstate = wall_data["visibleIfAny"][0]
	
	var ubergroup = int(location_uberstate["uberIdentifier"][0])
	var uberid = int(location_uberstate["uberIdentifier"][1])
	var value = roundi(location_uberstate["value"])  # Some uberstates are returned as 0.5
	# Are walls named in v5?
	return "on spawn store(%d|%d, %d)" % [ubergroup, uberid, value]

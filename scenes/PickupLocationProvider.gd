extends Node
class_name PickupLocationProvider

# Comparator enum
# https://github.com/ori-community/wotw-seedgen/blob/v5/wotw_seedgen_data/src/seed_language/ast/mod.rs#L342
enum IconVisibilityComparator {
	EQUAL = 0,
	NOT_EQUAL = 1,
	LESS = 2,
	LESS_OR_EQUAL = 3,
	GREATER = 4,
	GREATER_OR_EQUAL = 5
}
static var UberstateComparator = {
	# The icons' comparators indicate when the icon should exist in the map. Therefore, we need to map the inverse condition to give the pickups.
	# Fortunately, there are no cases of naturally decrementing uberstates.
	IconVisibilityComparator.EQUAL: null,  # Seedlang has no support for not being equal to a value
	IconVisibilityComparator.NOT_EQUAL: "=",
	IconVisibilityComparator.LESS: ">=",
	IconVisibilityComparator.LESS_OR_EQUAL: ">",
	IconVisibilityComparator.GREATER: "<=",
	IconVisibilityComparator.GREATER_OR_EQUAL: "<"
}


static var _locations_file:String = "res://data/map-icons.json"  # TODO: Fetch from API
var _locations_raw:Array
var locations_by_name:Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var data = JSON.parse_string(FileAccess.get_file_as_string(_locations_file))  # TODO: Fetch from API
	_locations_raw = data["mapIcons"]
	for location in _locations_raw:
		locations_by_name[location["label"]] = location

func location_as_condition_v4(location_name:String) -> String:
	var location_data = locations_by_name.get(location_name)
	var location_uberstate = location_data["visibleIfAny"][0]
	
	var ubergroup = int(location_uberstate["uberIdentifier"][0])
	var uberid = int(location_uberstate["uberIdentifier"][1])
	var operator = UberstateComparator[int(location_uberstate["comparator"])]
	var value = roundi(location_uberstate["value"])  # Some uberstates are returned as 0.5
	if operator == null and value == 0:  # Icon only exists when uberstate is untouched.
		operator = ">"  # Pickup is given with >0.
	
	var location_condition = "%d|%d%s%d" % [ubergroup, uberid, operator, value]
	return location_condition

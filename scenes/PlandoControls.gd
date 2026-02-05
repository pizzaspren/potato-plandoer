extends MarginContainer
class_name PlandoControls

var _pickup_data_provider:PickupDataProvider
var _pickup_location_provider:PickupLocationProvider


func _ready() -> void:
	_pickup_data_provider = get_tree().get_first_node_in_group("PickupDataProvider") as PickupDataProvider
	_pickup_location_provider = get_tree().get_first_node_in_group("PickupLocationProvider") as PickupLocationProvider


func _clipboard_v4() -> void:
	var body:String = _assignments_as_v4(_fetch_assignments())
	DisplayServer.clipboard_set(body)


func _clipboard_v5() -> void:
	var body:String = _assignments_as_v5(_fetch_assignments())
	DisplayServer.clipboard_set(body)


func _export_v4() -> void:
	var plando_name = %PlandoName.text if %PlandoName.text else %PlandoName.placeholder_text
	var header:String = _create_header(plando_name)
	var body:String = _assignments_as_v4(_fetch_assignments())
	if body.is_empty():
		pass  # TODO: Prevent download?
	_download_file(header + body, plando_name + ".wotwr")


func _export_v5() -> void:
	var plando_name = %PlandoName.text if %PlandoName.text else %PlandoName.placeholder_text
	var header:String = _create_header(plando_name)
	var body:String = _assignments_as_v5(_fetch_assignments())
	if body.is_empty():
		pass  # TODO: Prevent download?
	_download_file(header + body, plando_name + ".wotws")


func _create_header(slug:String) -> String:
	return "\n".join([
		"// Made with Pizza's Potato Plandoer",
		"",
		"// Format Version: 1.0.0",
		"// Slug: " + slug,
		r"""// Config: {"worldSettings":[{"spawn":"MarshSpawn.Main","difficulty":"Unsafe","hard":false,"randomizeDoors":false,"tricks":[],"goals":[],"headers":[],"headerConfig":[],"inlineHeaders":[]}],"disableLogicFilter":true,"online":false,"createGame":"None"}""",
		"",
	])


func _fetch_assignments() -> Array:
	var assignments:Array = []
	
	var nodes = get_tree().get_nodes_in_group("PickupLocations")
	for node in nodes:
		var target_location = node as PickupButton
		if !is_instance_valid(target_location) or target_location._selected_pickups.is_empty():
			continue
		for selected_pickup in target_location._selected_pickups:
			# Unmap from panel selection to pickup id
			var pickup_id = _pickup_data_provider.pickup_mapping.get(selected_pickup)
			if pickup_id == null:
				continue
			# Fetch pickup object
			var pickup = _pickup_data_provider.pickups_by_id[pickup_id]
			assignments.append([target_location, pickup])
	return assignments


func _assignments_as_v4(assignments: Array) -> String:
	var v4_contents:Array = []
	for a in assignments:
		var target_location:PickupButton = a[0]
		var pickup:Dictionary = a[1]
		
		var location_condition = _pickup_location_provider.location_as_condition_v4(target_location.name.replace("_", "."))
		var pickup_ubergroup = int(pickup["mapping"]["v4"]["group"])
		var pickup_uberid = int(pickup["mapping"]["v4"]["state"])
		
		if target_location._is_removing:
			pickup_uberid = -pickup_uberid
		v4_contents.append("%s|%d|%d" % [
			location_condition,
			pickup_ubergroup,
			pickup_uberid
		])
	return "\n".join(v4_contents)


func _assignments_as_v5(assignments: Array) -> String:
	var v5_contents:Array = []
	for a in assignments:
		var target_location:PickupButton = a[0]
		var pickup:Dictionary = a[1]
		
		var location_condition = _pickup_location_provider.location_as_condition_v5(target_location.name.replace("_", "."))
		var pickup_call = pickup["mapping"]["v5"]
		match pickup["type"]:
			"skill": pickup_call = "skill(%s)" % pickup_call
			"shard": pickup_call = "shard(%s)" % pickup_call
			"teleporter": pickup_call = "teleporter(%s)" % pickup_call
		if target_location._is_removing:
			# Extremely convenient
			pickup_call = "remove_%s" % pickup_call
		v5_contents.append("%s %s" % [location_condition, pickup_call])
	return "\n".join(v5_contents)


func _download_file(contents:String, filename:String) -> void:
	if OS.has_feature("editor"):
		print(contents)
	JavaScriptBridge.download_buffer(contents.to_utf8_buffer(), filename, "text/plain")

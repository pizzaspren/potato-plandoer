extends MarginContainer
class_name PlandoControls

var _pickup_data_provider:PickupDataProvider
var _pickup_location_provider:PickupLocationProvider
var _wall_location_provider:WallLocationProvider
var _file_access_web: FileAccessWeb = FileAccessWeb.new()

func _ready() -> void:
	_pickup_data_provider = get_tree().get_first_node_in_group("PickupDataProvider") as PickupDataProvider
	_pickup_location_provider = get_tree().get_first_node_in_group("PickupLocationProvider") as PickupLocationProvider
	_wall_location_provider = get_tree().get_first_node_in_group("WallLocationProvider") as WallLocationProvider
	_file_access_web.loaded.connect(_on_file_loaded)
	# TODO: Errors
	# _file_access_web.error.connect(...)


func _clipboard_v4() -> void:
	mouse_default_cursor_shape = Control.CURSOR_BUSY
	var pickups:String = _location_assignments_as_v4(_fetch_location_assignments())
	var walls:String = "\n".join(_fetch_toggled_walls().map(func _m(w): return _wall_location_provider.wall_as_v4(w)))
	var content = "\n".join([
		pickups,
		walls,
	])
	DisplayServer.clipboard_set(content)
	mouse_default_cursor_shape = Control.CURSOR_ARROW


func _clipboard_v5() -> void:
	mouse_default_cursor_shape = Control.CURSOR_BUSY
	var pickups:String = _location_assignments_as_v5(_fetch_location_assignments())
	var walls:String = "\n".join(_fetch_toggled_walls().map(func _m(w): return _wall_location_provider.wall_as_v5(w)))
	var content = "\n".join([
		pickups,
		walls,
	])
	DisplayServer.clipboard_set(content)
	mouse_default_cursor_shape = Control.CURSOR_ARROW


func _export_v4() -> void:
	mouse_default_cursor_shape = Control.CURSOR_BUSY
	var plando_name = %PlandoName_V4.text if %PlandoName_V4.text else %PlandoName_V4.placeholder_text
	var header:String = _create_header(plando_name)
	var pickups:String = _location_assignments_as_v4(_fetch_location_assignments())
	var walls:String = "\n".join(_fetch_toggled_walls().map(func _m(w): return _wall_location_provider.wall_as_v4(w)))
	if pickups.is_empty() and walls.is_empty():
		pass  # TODO: Prevent download?
	var content = "\n".join([
		header,
		"",
		"// User-placed pickups",
		pickups,
		walls,
	])
	_download_file(content, plando_name + ".wotwr")
	mouse_default_cursor_shape = Control.CURSOR_ARROW


func _export_v5() -> void:
	mouse_default_cursor_shape = Control.CURSOR_BUSY
	var plando_name = %PlandoName_V5.text if %PlandoName_V5.text else %PlandoName_V5.placeholder_text
	var pickups:String = _location_assignments_as_v5(_fetch_location_assignments())
	var walls:String = "\n".join(_fetch_toggled_walls().map(func _m(w): return _wall_location_provider.wall_as_v5(w)))
	if pickups.is_empty() and walls.is_empty():
		pass  # TODO: Prevent download?
	var content = "\n".join([
		pickups,
		walls,
	])
	_download_file(content, plando_name + ".wotws")
	mouse_default_cursor_shape = Control.CURSOR_ARROW


func _create_header(slug:String) -> String:
	return "\n".join([
		"// Made with Pizza's Potato Plandoer",
		"",
		"// Format Version: 1.0.0",
		"// Slug: " + slug,
		r"""// Config: {"worldSettings":[{"spawn":"MarshSpawn.Main","difficulty":"Unsafe","hard":false,"randomizeDoors":false,"tricks":[],"goals":[],"headers":[],"headerConfig":[],"inlineHeaders":[]}],"disableLogicFilter":true,"online":false,"createGame":"None"}""",
		"",
		"// Seedgen core",  # https://github.com/ori-community/wotw-seedgen/blob/main/wotw_seedgen/src/generator/seed_core.wotwr
		"""3|0|8|7|12|bool|true
3|0|8|6|402|bool|true
3|0|8|48248|16489|int|1
3|0|8|17|16825|bool|true
3|0|8|21|16825|bool|true
3|0|8|17|15068|bool|true
3|0|8|21|15068|bool|true
3|0|8|21786|47458|bool|true
3|0|8|937|54318|bool|true
3|0|8|9593|3621|bool|true
3|0|8|21786|50432|bool|true
3|0|8|58674|22056|bool|true
3|0|8|58674|32369|bool|true
3|0|8|58674|14539|bool|true
3|0|8|58674|61252|bool|true
3|0|8|58674|10677|bool|true
3|0|8|58674|36965|bool|true
3|0|8|58674|7636|bool|true
3|0|8|14019|8973|int|1
3|0|8|14019|35087|int|1
3|0|8|14019|35399|int|1
3|0|8|14019|45931|int|1
3|0|8|58674|46980|bool|true
3|0|8|58674|44798|int|2
3|0|8|14019|54675|int|2
3|0|8|14019|34504|int|4
3|0|8|14019|44500|int|4
3|0|8|21786|26462|bool|true
3|0|8|7|13|bool|true
3|0|8|7|14|bool|true
3|0|8|7|15|bool|true
3|0|8|7|16|bool|true
3|0|8|7|17|bool|true
3|0|8|7|18|bool|true
3|0|8|7|19|bool|true
3|0|8|7|103|bool|true
9|0|8|9|0|int|0
3|1|17|0|17|16825|grom:0
3|1|17|1|17|16825|Repair the Spirit Well
3|1|17|2|17|16825|They say the spirit of old could #warp# from one well to another. Perhaps if we #repaired this well with Gorlek Ore#, returning to the #Wellspring Glades# would be even easier.
3|1|8|17|16826|int|1
17|16825|8|21|16825|bool|true
3|1|17|0|17|51230|grom:1
3|1|17|1|17|51230|Dwelling Repairs
3|1|17|2|17|51230|It's a shame how those old Moki dwellings are in shambles. Maybe if we #fixed them up# the Moki could #move back to the Glades#?
3|1|8|17|51231|int|4
17|51230|8|21|51230|bool|true
3|1|17|0|17|23607|grom:3
3|1|17|1|17|23607|Roofs Over Heads
3|1|17|2|17|23607|Time to #build some more housing#! Now on the big tree, by the fire.
3|1|4|17|17|51230|0|17|4|17|23607|false
17|51230|17|4|17|23607|true
3|1|8|17|23608|int|6
17|23607|8|21|23607|bool|true
3|1|17|0|17|40448|grom:5
3|1|17|1|17|40448|Onwards and Upwards
3|1|17|2|17|40448|Treehouses seem to be popular with the Moki. How about we add a couple more?
3|1|4|17|17|23607|0|17|4|17|40448|false
17|23607|17|4|17|40448|true
3|1|8|17|40449|int|8
17|40448|8|21|40448|bool|true
3|1|17|0|17|18751|grom:2
3|1|17|1|17|18751|Thorny Situation
3|1|17|2|17|18751|Those spikey vines all over the place are quite the nuisance, let me tell you. With some help, I could #clear them out# and #make the Glades safer# for everyone!
3|1|8|17|18752|int|5
17|18751|8|21|18751|bool|true
3|1|17|0|17|16586|grom:4
3|1|17|1|17|16586|Clear the Cave Entrance
3|1|17|2|17|16586|That old cave entrance looks like it's #about to collapse#...but we Gorlek learned a thing or two about tunnelling after fleeing to the mines. With some Ore, I can #repair# it.
3|1|4|17|17|18751|0|17|4|17|16586|false
17|18751|17|4|17|16586|true
17|18751|4|17|14019|33776|0|8|14019|33776|byte|1
3|1|8|17|16587|int|6
17|16586|8|21|16586|bool|true
3|1|17|0|17|15068|grom:6
3|1|17|1|17|15068|The Gorlek Touch
3|1|17|2|17|15068|The Moki are right...building it only half the work. Nothing's quite complete without some #finishing touches# of decoration.
3|1|8|17|15069|int|10
17|15068|8|21|15068|bool|true
3|1|17|0|20|16254|tuley:0
3|1|17|1|20|16254|Wellspring Wildflowers
3|1|17|2|20|16254|I could never quite get #Sela flowers# to prosper in my old garden. Perhaps they'll do better here?
3|1|4|17|14019|20601|0|17|4|20|16254|false
14019|20601|17|4|20|16254|true
20|16254|8|21|16254|bool|false
3|1|17|0|20|64583|tuley:1
3|1|17|1|20|64583|Sticky Situation
3|1|17|2|20|64583|I'm not surprised you found this seed so far away. Feel how sticky it is? Grass seeds hitch rides on passers-by to find fresh soil.
3|1|4|17|14019|28662|0|17|4|20|64583|false
14019|28662|17|4|20|64583|true
20|64583|8|21|64583|bool|false
3|1|17|0|20|47651|tuley:2
3|1|17|1|20|47651|Firemoth's Delight
3|1|17|2|20|47651|With the days growing darker since the #Decay#, Lightcatchers are finding it harder to collect the light they need for their hanging bulbs.
3|1|4|17|14019|8192|0|17|4|20|47651|false
14019|8192|17|4|20|47651|true
20|47651|8|21|47651|bool|false
3|1|17|0|20|33011|tuley:3
3|1|17|1|20|33011|Blue Moon
3|1|17|2|20|33011|Unlike their cousins, the #Lightcatchers#, these hanging flowers draw energy from the light of the #moon#, not the sun.
3|1|4|17|14019|24142|0|17|4|20|33011|false
14019|24142|17|4|20|33011|true
20|33011|8|21|33011|bool|false
3|1|17|0|20|38393|tuley:4
3|1|17|1|20|38393|Left Behind
3|1|17|2|20|38393|I thought I saved every seed, but it seems on was left behind in the cold, and survived against all odds.
3|1|4|17|14019|32376|0|17|4|20|38393|false
14019|32376|17|4|20|38393|true
20|38393|8|21|38393|bool|false
3|1|17|0|20|40006|tuley:5
3|1|17|1|20|40006|The Last Seed
3|1|17|2|20|40006|I recognize this seed. It seems the tree I couldn't save is not completely gone.
3|1|4|17|14019|7470|0|17|4|20|40006|false
14019|7470|17|4|20|40006|true
20|40006|8|21|40006|bool|false
0|100|8|6|401|bool|true
14019|27804=2|4|17|14019|57399|1|8|14019|27804|int|3
14019|27804>2|4|17|6|500|0|4|17|21|51230|1|8|14019|27804|int|1
14019|27804>2|4|17|6|500|0|4|17|21|51230|0|8|14019|27804|int|0"""
	])


func _fetch_location_assignments() -> Array[Dictionary]:
	var assignments:Array[Dictionary] = []
	
	var nodes = get_tree().get_nodes_in_group("PickupLocations")
	for node in nodes:
		var target_location = node as PickupButton
		if !is_instance_valid(target_location) or target_location._model.is_empty():
			continue
			
		if target_location._model.removed:
			assignments.append({"location": target_location, "removed": true})
			continue
		if target_location._model.message:
			var message_data = {"location": target_location, "message": {"text": target_location._model.message}}
			if target_location._model.message_frames != 240:
				message_data["message"]["duration_frames"] = target_location._model.message_frames
			assignments.append(message_data)
		var pickups_muted = target_location._model.mute_pickups
		var pickups_for_location = target_location._model.data
		for selected_pickup in pickups_for_location:
			# Unmap from panel selection to pickup id
			var pickup_id = _pickup_data_provider.pickup_mapping.get(selected_pickup)
			if pickup_id == null:
				continue
			# Fetch pickup object
			var pickup = _pickup_data_provider.pickups_by_id[pickup_id]
			var is_taking_away = pickups_for_location[selected_pickup] == PanelPickupModel.PickupState.TAKE
			assignments.append({"location": target_location, "pickup": {"data": pickup, "removing": is_taking_away, "muted": pickups_muted}})
	return assignments


func _fetch_toggled_walls() -> Array:
	var toggled_walls = []
	
	var all_walls = get_tree().get_nodes_in_group("WallLocations")
	for wall in all_walls:
		if wall.button_pressed:
			toggled_walls.append(wall.name)
	return toggled_walls


func _location_assignments_as_v4(assignments: Array[Dictionary]) -> String:
	var v4_contents:Array = []
	for a in assignments:
		var target_location:PickupButton = a["location"]
		var location_condition = _pickup_location_provider.location_as_condition_v4(target_location.name.replace("_", "."))
		
		if a.has("removed"):
			v4_contents.append("3|0|%s" % _pickup_location_provider.location_as_assignment_v4(target_location.name.replace("_", ".")))

		if a.has("message"):
			var text = a["message"]["text"]
			var custom_duration = a["message"].get("duration_frames", null)
			var message_statement = "%s|6|%s" % [location_condition, text]
			if custom_duration:
				message_statement += "|f=%d" % custom_duration
			v4_contents.append(message_statement)

		if a.has("pickup"):
			var pickup:Dictionary = a["pickup"]["data"]
			var taking_away:bool = a["pickup"]["removing"]
			var muted:bool = a["pickup"]["muted"]
			
			var pickup_ubergroup = int(pickup["mapping"]["v4"]["group"])
			var pickup_uberid = int(pickup["mapping"]["v4"]["state"])
			
			if taking_away:
				pickup_uberid = -pickup_uberid
			var pickup_statement = "%s|%d|%d" % [
				location_condition,
				pickup_ubergroup,
				pickup_uberid
			]
			if muted:
				pickup_statement += "|mute"
			v4_contents.append(pickup_statement)
	return "\n".join(v4_contents)


func _location_assignments_as_v5(assignments: Array[Dictionary]) -> String:
	var v5_contents:Array = []
	for a in assignments:
		var target_location:PickupButton = a["location"]
		var location_condition = _pickup_location_provider.location_as_condition_v5(target_location.name.replace("_", "."))

		if a.has("removed"):
			v5_contents.append("on spawn %s" % _pickup_location_provider.location_as_assignment_v5(target_location.name.replace("_", ".")))

		if a.has("message"):
			var text = a["message"]["text"]
			var custom_duration = a["message"].get("duration_frames", null)
			if custom_duration:
				v5_contents.append("%s item_message_with_timeout(\"%s\", %d)" % [location_condition, text.replace("\"", "\\\""), custom_duration])
			else:
				v5_contents.append("%s item_message(\"%s\")" % [location_condition, text.replace("\"", "\\\"")])
		
		if a.has("pickup"):
			var pickup:Dictionary = a["pickup"]["data"]
			var taking_away:bool = a["pickup"]["removing"]
			# FIXME: v5 adds item messages by default and there's no easy way to map calls to states
			# var muted:bool = a["pickup"]["muted"]  
			
			var pickup_call = pickup["mapping"]["v5"]
			match pickup["type"]:
				"skill": pickup_call = "skill(%s)" % pickup_call
				"shard": pickup_call = "shard(%s)" % pickup_call
				"teleporter": pickup_call = "teleporter(%s)" % pickup_call
			if taking_away:
				# Extremely convenient
				pickup_call = "remove_%s" % pickup_call
			v5_contents.append("%s %s" % [location_condition, pickup_call])
	return "\n".join(v5_contents)


func _download_file(contents:String, filename:String) -> void:
	if OS.has_feature("editor"):
		print(contents)
	JavaScriptBridge.download_buffer(contents.to_utf8_buffer(), filename, "text/plain")


func _on_save_json() -> void:
	var exportable_json = {}
	# I really don't like doing this here, but it works for now
	var get_pickups = func gp() -> Dictionary:
		var exportable = {}
		var nodes = get_tree().get_nodes_in_group("PickupLocations")
		for node in nodes:
			var target_location = node as PickupButton
			if !is_instance_valid(target_location) or target_location._model.is_empty():
				continue
			exportable[target_location.name] = target_location._model.as_dict()
		return exportable
	exportable_json["pickups"] = get_pickups.call()
	exportable_json["toggles"] = _fetch_toggled_walls()
	_download_file(JSON.stringify(exportable_json), "ppp.json")


func _on_load_json() -> void:
	_file_access_web.open("*.json")


func _on_file_loaded(_file_name: String, _type: String, base64_data: String) -> void:
	var contents = JSON.parse_string(Marshalls.base64_to_utf8(base64_data))
	# I really don't like doing this here, but it works for now
	var pickups = contents["pickups"] as Dictionary
	var locations_with_assignments = get_tree().get_nodes_in_group("PickupLocations") \
			.filter(func f(n): return pickups.has(n.name))
	for node in locations_with_assignments as Array[PickupButton]:
		node._model.from_dict(pickups.get(node.name))
		node.update_modulation()
	var toggles = contents["toggles"] as Array
	var pressed_togglables = get_tree().get_nodes_in_group("WallLocations") \
			.filter(func f(n): return toggles.has(n.name))
	for node in pressed_togglables as Array[WallButton]:
		node.set_pressed_no_signal(true)
		node.update_modulation()

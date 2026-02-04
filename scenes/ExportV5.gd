extends Button

var _pickup_data_provider:PickupDataProvider
var _pickup_location_provider:PickupLocationProvider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_pickup_data_provider = get_tree().get_first_node_in_group("PickupDataProvider") as PickupDataProvider
	_pickup_location_provider = get_tree().get_first_node_in_group("PickupLocationProvider") as PickupLocationProvider


func _on_pressed() -> void:
	var output:Array[String] = []
	var nodes = get_tree().get_nodes_in_group("PickupLocations")
	for node in nodes:
		var target_location = node as PickupButton
		if !is_instance_valid(target_location):
			continue
		
		if target_location._selected_pickups.is_empty():
			continue
			
		var location_condition = _pickup_location_provider.location_as_condition_v5(target_location.name.replace("_", "."))
		
		for selected_pickup in target_location._selected_pickups:
			var pickup_id = _pickup_data_provider.pickup_mapping.get(selected_pickup)
			if pickup_id == null:
				continue
			var pickup = _pickup_data_provider.pickups_by_id[pickup_id]
			var pickup_call = pickup["mapping"]["v5"]
			match pickup["type"]:
				"skill": pickup_call = "skill(%s)" % pickup_call
				"shard": pickup_call = "shard(%s)" % pickup_call
				"teleporter": pickup_call = "teleporter(%s)" % pickup_call
			if target_location._is_removing:
				# Extremely convenient
				pickup_call = "remove_%s" % pickup_call
			output.append("%s %s" % [location_condition, pickup_call])
	
	print("Temp export for v5:")
	for line in output:
		print(line)
		

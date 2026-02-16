extends Object
class_name PanelPickupModel

enum PickupState {
	SKIP = 0,
	GIVE = 1,
	TAKE = 2
}

var data:Dictionary[int, PickupState]

var message:String = ""
var message_frames:int = 240
var mute_pickups:bool = false

var removed:bool = false


func is_empty() -> bool:
	return data.is_empty() and message.is_empty() and !removed

func as_dict() -> Dictionary:
	return {
		"data": data,
		"message": message,
		"message_frames": message_frames,
		"mute_pickups": mute_pickups,
		"removed": removed,
	}


func from_dict(d: Dictionary) -> void:
	var mapped_data:Dictionary[int,PickupState] = {} as Dictionary[int,PickupState]
	for k in d.get("data", {}).keys():
		mapped_data[int(k)] = int(d.get("data")[k]) as PickupState
	print(mapped_data)
	data = mapped_data
	message = d.get("message", "")
	message_frames = d.get("message_frames", 240)
	mute_pickups = d.get("mute_pickups", false)
	removed = d.get("removed", false)

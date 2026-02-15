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

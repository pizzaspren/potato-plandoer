extends Object
class_name PanelPickupModel

enum PickupState {
	SKIP = 0,
	GIVE = 1,
	TAKE = 2
}

var removed:bool = false
var message:String = ""
var data:Dictionary[int, PickupState]


func is_empty() -> bool:
	return data.is_empty() and message.is_empty()

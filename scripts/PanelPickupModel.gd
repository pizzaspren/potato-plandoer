extends Object
class_name PanelPickupModel

enum PickupState {
	SKIP = 0,
	GIVE = 1,
	TAKE = 2
}

var removed:bool = false
var data:Dictionary[int, PickupState]

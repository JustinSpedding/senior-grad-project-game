extends Camera

func _ready():
	set_fixed_process(true)

export var look_at_player = false
var queued = false
var time = 0

func _fixed_process(delta):
	if look_at_player:
		look_at(get_parent().get_node("player").get_global_transform().origin, Vector3(0,1,0))
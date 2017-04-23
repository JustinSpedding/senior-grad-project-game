extends Camera

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_fixed_process(true)
	pass
	
var queued = false
var time = 0
func _fixed_process(delta):
	pass
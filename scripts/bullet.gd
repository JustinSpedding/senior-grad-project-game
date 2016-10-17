
extends Spatial

var speed = 0
var time_to_live = 3

func _ready():
	set_process(true)

func _process(delta):
	var bullet = get_node("bullet")
	bullet.translate(Vector3(0, 0, -speed)*delta)
	
	time_to_live -= delta
	if (time_to_live <= 0):
		queue_free()
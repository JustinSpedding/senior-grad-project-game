
extends Spatial

var velocity = Vector3(0,0,0)
var time_to_live = 1

func _ready():
	set_process(true)

func _process(delta):
	var bullet = get_node("bullet")
	var location = bullet.get_transform()
	location.origin += velocity*delta
	bullet.set_transform(location)
	
	time_to_live -= delta
	if (time_to_live <= 0):
		queue_free()
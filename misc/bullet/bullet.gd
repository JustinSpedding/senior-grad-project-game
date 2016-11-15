
extends KinematicBody

var speed
var damage
var time_to_live = 3
var target_group

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	translate(Vector3(0, 0, -speed)*delta)
	
	for object in get_tree().get_nodes_in_group(target_group):
		if is_close_enough(get_global_transform().origin, object.get_global_transform().origin, 0.5):
			object.health -= damage
			queue_free()
			break
	
	time_to_live -= delta
	if (time_to_live <= 0):
		queue_free()

func is_close_enough(point1, point2, distance):
	var diff = (point1 - point2).abs()
	return diff.x <= distance && diff.y <= distance && diff.z <= distance
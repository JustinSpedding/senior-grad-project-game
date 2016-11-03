
extends KinematicBody

var speed = 0
var damage = 200
var time_to_live = 3

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	translate(Vector3(0, 0, -speed)*delta)
	
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if is_close_enough(get_global_transform().origin, enemy.get_global_transform().origin, 0.5):
			enemy.health -= damage
			queue_free()
			break
	
	time_to_live -= delta
	if (time_to_live <= 0):
		queue_free()

func is_close_enough(point1, point2, distance):
	var diff = (point1 - point2).abs() 
	return diff.x <= distance && diff.y <= distance && diff.z <= distance
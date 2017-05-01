
extends KinematicBody

var speed
var damage
var time_to_live = 1
var target_group
var target_ref

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	# If it has a target, look at it
	if (target_ref != null and target_ref.get_ref()):
		look_at(target_ref.get_ref().get_global_transform().origin, Vector3(0,1,0))
	
	# Move forward
	translate(Vector3(0, 0, -speed)*delta)
	
	# Check to see it it hit its target
	for object in get_tree().get_nodes_in_group(target_group):
		if is_close_enough(get_global_transform().origin, object.get_global_transform().origin, 0.5):
			object.health -= damage
			queue_free()
			break
	
	# If it has been alive for too long, assume it missed
	time_to_live -= delta
	if (time_to_live <= 0):
		queue_free()

func is_close_enough(point1, point2, distance):
	var diff = (point1 - point2).abs()
	return diff.x <= distance && diff.y <= distance && diff.z <= distance
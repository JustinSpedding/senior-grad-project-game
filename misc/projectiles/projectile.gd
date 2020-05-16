extends KinematicBody

class_name Projectile

var speed: float
var damage: int
var time_to_live: float = 1
var target_group: String
var target_ref: WeakRef

func _ready() -> void:
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	# If it has a target, look at it
	if (target_ref != null and target_ref.get_ref()):
		look_at(target_ref.get_ref().get_global_transform().origin, Vector3(0.0, 1.0, 0.0))
	
	# Move forward
	translate(Vector3(0.0, 0.0, -speed) * delta)
	
	# Check to see it it hit its target
	for object in get_tree().get_nodes_in_group(target_group):
		if is_close_enough(get_global_transform().origin, object.get_global_transform().origin, 0.5):
			object.health -= damage
			queue_free()
			break
	
	# If it has been alive for too long, assume it missed
	time_to_live -= delta
	if (time_to_live <= 0.0):
		queue_free()

func is_close_enough(point1: Vector3, point2: Vector3, distance: float) -> bool:
	var diff: Vector3 = (point1 - point2).abs()
	return diff.x <= distance && diff.y <= distance && diff.z <= distance

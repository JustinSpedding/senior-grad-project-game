
extends KinematicBody

const homing_speed_forward = 20
const homing_speed_sideways = 5
const attack_damage = 300

var target
var health = 1000

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	if health <= 0:
		queue_free()
	if target != null:
		home(delta)

func home(delta):
	# Move closer to target
	var a = target.get_global_transform().origin * delta * homing_speed_sideways
	var b = get_global_transform().origin * delta * homing_speed_sideways
	translate(Vector3(a.x - b.x, a.y - b.y, homing_speed_forward * delta + abs(a.z - b.z)))
	
	#translate(((target.get_global_transform().origin - get_global_transform().origin) * delta * homing_speed_sideways) + Vector3(0, 0, homing_speed_forward * delta))

	# Damage player and switch to homing if hit target
	if is_close_enough(get_global_transform().origin, target.get_global_transform().origin, 0.5):
		target.health -= attack_damage
		queue_free()

	# Die if already passed player
	if target.get_global_transform().origin.z <= get_global_transform().origin.z - 10:
		queue_free()

func is_close_enough(point1, point2, distance):
	var diff = (point1 - point2).abs()
	return diff.x <= distance && diff.y <= distance && diff.z <= distance
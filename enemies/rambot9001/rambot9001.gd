
extends KinematicBody

const STATE = {
	Homing = 0,
	Charging = 1,
	Attacking = 2
}

const attack_distance = 4
const charge_time = 0.5

var target
var health = 1000
var state = STATE.Homing
var charge_time_remaining

func _ready():
	set_fixed_process(true)
	
func setTarget(t):
	target = t

func _fixed_process(delta):
	if health <= 0:
		queue_free()
	
	if target != null:
		if (state == STATE.Homing):
			home()
		elif (state == STATE.Charging):
			charge(delta)
		elif (state == STATE.Attacking):
			attack()

func home():
	# Move closer to target
	move((target.get_global_transform().origin + Vector3(0, 0, -attack_distance) - get_global_transform().origin) * 0.1);
	
	# Switch to attacking state if the rambot is already close enough to the target
	if (isCloseEnough(target.get_global_transform().origin + Vector3(0, 0, -attack_distance), get_global_transform().origin, 0.7)):
		state = STATE.Charging
		charge_time_remaining = charge_time

func charge(delta):
	charge_time_remaining -= delta
	if charge_time_remaining < 0:
		state = STATE.Attacking

func attack():
	# Attack in straight line
	move(Vector3(0, 0, 0.2))
	
	# Switch to homing if passed target or colliding with target
	if target.get_global_transform().origin.z <= get_global_transform().origin.z or (is_colliding() and get_collider() == target):
		state = STATE.Homing

func isCloseEnough(point1, point2, distance):
	var diff = (point1 - point2).abs()
	return diff.x <= distance && diff.y <= distance && diff.z <= distance
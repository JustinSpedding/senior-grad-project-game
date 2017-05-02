extends "res://enemies/enemy.gd"

const STATE = {
	Homing = 0,
	Charging = 1,
	Attacking = 2
}

const homing_speed = 5
const homing_distance = 4
const attacking_speed = 20
const attack_damage = 100
const charge_time = 0.5

var target
var health = 2000
var state = STATE.Homing
var charge_time_remaining

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if health <= 0:
		explode()
	
	if target != null:
		if (state == STATE.Homing):
			home(delta)
		elif (state == STATE.Charging):
			charge(delta)
		elif (state == STATE.Attacking):
			attack(delta)

func home(delta):
	# Move closer to target
	translate((target.get_global_transform().origin + Vector3(0, 0, -homing_distance) - get_global_transform().origin) * delta * homing_speed);
	
	# Switch to charging state if the rambot is already close enough to the target
	if (is_close_enough(target.get_global_transform().origin + Vector3(0, 0, -homing_distance), get_global_transform().origin, 0.7)):
		state = STATE.Charging
		charge_time_remaining = charge_time

func charge(delta):
	charge_time_remaining -= delta
	if charge_time_remaining <= 0:
		state = STATE.Attacking

func attack(delta):
	# Attack in straight line
	translate(Vector3(0, 0, delta * attacking_speed))
	
	# Switch to homing if passed target
	if target.get_global_transform().origin.z <= get_global_transform().origin.z:
		state = STATE.Homing
	
	# Damage player and switch to homing if hit target
	if is_close_enough(get_global_transform().origin, target.get_global_transform().origin, 0.5):
		target.health -= attack_damage
		state = STATE.Homing

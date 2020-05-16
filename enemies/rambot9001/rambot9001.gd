extends "res://enemies/enemy.gd"

class_name Rambot9001

const STATE = {
	Homing = 0,
	Charging = 1,
	Attacking = 2
}

const homing_speed: float = 5.0
const homing_distance: float = 4.0
const attacking_speed: float = 20.0
const attack_damage: int = 100
const charge_time: float = 0.5

var charge_time_remaining: float = charge_time

func _ready() -> void:
	set_physics_process(true)
	health = 2000
	state = STATE.Homing

func _physics_process(delta: float) -> void:
	if health <= 0:
		explode()
	
	if target != null:
		if (state == STATE.Homing):
			home(delta)
		elif (state == STATE.Charging):
			charge(delta)
		elif (state == STATE.Attacking):
			attack(delta)

func home(delta: float) -> void:
	# Move closer to target
	translate((target.get_global_transform().origin + Vector3(0.0, 0.0, -homing_distance) - get_global_transform().origin) * (delta * homing_speed))
	
	# Switch to charging state if the rambot is already close enough to the target
	if (is_close_enough(target.get_global_transform().origin + Vector3(0.0, 0.0, -homing_distance), get_global_transform().origin, 0.7)):
		state = STATE.Charging
		charge_time_remaining = charge_time

func charge(delta: float) -> void:
	charge_time_remaining -= delta
	if charge_time_remaining <= 0:
		state = STATE.Attacking

func attack(delta: float) -> void:
	# Attack in straight line
	translate(Vector3(0.0, 0.0, delta * attacking_speed))
	
	# Switch to homing if passed target
	if target.get_global_transform().origin.z <= get_global_transform().origin.z:
		state = STATE.Homing
	
	# Damage player and switch to homing if hit target
	if is_close_enough(get_global_transform().origin, target.get_global_transform().origin, 0.5):
		target.health -= attack_damage
		state = STATE.Homing

extends "res://enemies/enemy.gd"

const homing_speed_forward: float = 20.0
const homing_speed_sideways: float = 5.0
const attack_damage: int = 300

func _ready() -> void:
	set_physics_process(true)
	health = 1000
	
func _physics_process(delta: float) -> void:
	if health <= 0:
		explode()

	if target != null:
		home(delta)

func home(delta: float) -> void:
	# Move closer to target
	var a: Vector3 = target.get_global_transform().origin * (delta * homing_speed_sideways)
	var b: Vector3 = get_global_transform().origin * (delta * homing_speed_sideways)
	translate(Vector3(a.x - b.x, a.y - b.y, homing_speed_forward * delta + abs(a.z - b.z)))

	# Damage player and switch to homing if hit target
	if is_close_enough(get_global_transform().origin, target.get_global_transform().origin, 0.5):
		target.health -= attack_damage
		queue_free()

	# Die if already passed player
	if target.get_global_transform().origin.z <= get_global_transform().origin.z - 10.0:
		queue_free()

extends "res://enemies/enemy.gd"

class_name Shooter

var projectile_scene: PackedScene = load("res://misc/projectiles/bullet.tscn")

const STATE = {
	Homing = 0,
	Wandering = 1
}

const homing_speed: float = 5.0
const homing_distance: float = 8.0
const wandering_speed: float = 3.0
const wandering_x_bound: float = 5.0
const wandering_y_bound: float = 3.0

const projectile_speed: float = 40.0
const projectile_damage: int = 100

var direction: Vector3

func _ready() -> void:
	set_physics_process(true)
	health = 1000
	state = STATE.Homing

func _physics_process(delta: float) -> void:
	if health <= 0:
		explode()
	
	if target != null:
		if (state == STATE.Homing):
			home(delta)
		elif (state == STATE.Wandering):
			wander(delta)

func home(delta: float) -> void:
	# Move closer to target
	translate((target.get_global_transform().origin + Vector3(0.0, 0.0, -homing_distance) - get_global_transform().origin) * (delta * homing_speed))
	
	# Switch to wandering state if the shooter is already close enough to the target
	if (is_close_enough(target.get_global_transform().origin + Vector3(0.0, 0.0, -homing_distance), get_global_transform().origin, 0.7)):
		state = STATE.Wandering
		direction = Vector3(randf(), randf(), 0.0)

func wander(delta: float) -> void:
	translate(direction * (delta * wandering_speed))
	var new_location: Vector3 = get_global_transform().origin
	if new_location.x <= -wandering_x_bound:
		direction = Vector3(1.0, randf(), 0.0)
	if new_location.x >= wandering_x_bound:
		direction = Vector3(-1.0, randf(), 0.0)
	if new_location.y <= -wandering_y_bound:
		direction = Vector3(randf(), 1.0, 0.0)
	if new_location.y >= wandering_y_bound:
		direction = Vector3(randf(), -1.0, 0.0)

func shoot() -> void:
	var projectile = projectile_scene.instance()
	projectile.speed = projectile_speed
	projectile.damage = projectile_damage
	projectile.target_group = "player"
	get_parent().get_parent().add_child(projectile)
	projectile.set_transform(get_global_transform())
	projectile.look_at(get_global_transform().origin + Vector3(0.0, 0.0, 1.0), Vector3(0.0, 1.0, 0.0))

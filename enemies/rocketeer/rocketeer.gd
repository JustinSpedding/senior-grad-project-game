
extends KinematicBody

var projectile_scene = load("res://misc/projectiles/missile.tscn")

const STATE = {
	Homing = 0,
	Wandering = 1
}

const homing_speed = 5
const homing_distance = 7
const wandering_speed = 3
const wandering_x_bound = 5
const wandering_y_bound = 3

const projectile_speed = 10
const projectile_damage = 300

var target
var health = 2000
var state = STATE.Homing
var direction

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if health <= 0:
		queue_free()
	
	if target != null:
		if (state == STATE.Homing):
			home(delta)
		elif (state == STATE.Wandering):
			wander(delta)

func home(delta):
	# Move closer to target
	translate((target.get_global_transform().origin + Vector3(0, 0, -homing_distance) - get_global_transform().origin) * delta * homing_speed);
	
	# Switch to wandering state if the shooter is already close enough to the target
	if (is_close_enough(target.get_global_transform().origin + Vector3(0, 0, -homing_distance), get_global_transform().origin, 0.7)):
		state = STATE.Wandering
		direction = Vector3(randf(), randf(), 0)

func wander(delta):
	translate(delta * direction * wandering_speed)
	var new_location = get_global_transform().origin
	if new_location.x <= -wandering_x_bound:
		direction = Vector3(1, randf(), 0)
	if new_location.x >= wandering_x_bound:
		direction = Vector3(-1, randf(), 0)
	if new_location.y <= -wandering_y_bound:
		direction = Vector3(randf(), 1, 0)
	if new_location.y >= wandering_y_bound:
		direction = Vector3(randf(), -1, 0)

func shoot():
	var projectile = projectile_scene.instance()
	projectile.speed = projectile_speed
	projectile.damage = projectile_damage
	projectile.target_group = "player"
	get_parent().get_parent().add_child(projectile)
	projectile.set_transform(get_global_transform())
	projectile.look_at(get_global_transform().origin + Vector3(0,0,1), Vector3(0,1,0))

func is_close_enough(point1, point2, distance):
	var diff = (point1 - point2).abs()
	return diff.x <= distance && diff.y <= distance && diff.z <= distance
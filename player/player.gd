
extends KinematicBody

var bullet_scene = load("res://misc/bullet/bullet.tscn")

var max_speed = 10
var friction = .5
var acceleration_magnitude = 1
var primary_fire_cooldown = 0.1
var primary_fire_bullet_speed = 20

var speed_vector = Vector3(0, 0, 0)
var primary_fire_time_remaining = 0

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var acceleration = Vector3(0, 0, 0)
	if (Input.is_action_pressed("ui_down")):
		acceleration -= Vector3(0, 1, 0)
	if (Input.is_action_pressed("ui_up")):
		acceleration += Vector3(0, 1, 0)
	if (Input.is_action_pressed("ui_left")):
		acceleration -= Vector3(1, 0, 0)
	if (Input.is_action_pressed("ui_right")):
		acceleration += Vector3(1, 0, 0)
	acceleration = acceleration.normalized() * acceleration_magnitude
	var friction_vector = speed_vector.normalized() * friction
	speed_vector += acceleration - friction_vector
	if (speed_vector.length() > max_speed):
		speed_vector = speed_vector.normalized() * max_speed
	if (abs(speed_vector.x) < friction):
		speed_vector.x = 0
	if (abs(speed_vector.y) < friction):
		speed_vector.y = 0
	translate(speed_vector * delta)
	
	primary_fire_time_remaining -= delta
	if (Input.is_action_pressed("player_fire_primary") && primary_fire_time_remaining <= 0):
		primary_fire_time_remaining = primary_fire_cooldown
		var bullet = bullet_scene.instance()
		bullet.speed = primary_fire_bullet_speed
		get_tree().get_root().get_node("world").add_child(bullet)
		bullet.set_transform(get_global_transform())

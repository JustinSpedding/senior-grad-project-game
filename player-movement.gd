extends Node

var max_speed = 2
var friction = .25
var acceleration_magnitude = .5
var primary_fire_cooldown = 0
var bullet_scene = load("res://bullet-scene.tscn")
var speed_vector = Vector3(0, 0, 0)


func _ready():
	set_process(true)

func _process(delta):
	var player = get_node("player")
	var acceleration = Vector3(0, 0, 0)
	if (Input.is_action_pressed("ui_down")):
		acceleration += Vector3(0, 0, 1)
	if (Input.is_action_pressed("ui_up")):
		acceleration -= Vector3(0, 0, 1)
	if (Input.is_action_pressed("ui_left")):
		acceleration += Vector3(1, 0, 0)
	if (Input.is_action_pressed("ui_right")):
		acceleration -= Vector3(1, 0, 0)
	acceleration = acceleration.normalized() * acceleration_magnitude
	var friction_vector = speed_vector.normalized() * friction
	speed_vector += acceleration - friction_vector
	if (speed_vector.length() > max_speed):
		speed_vector = speed_vector.normalized() * max_speed
	if (abs(speed_vector.x) < friction):
		speed_vector.x = 0
	if (abs(speed_vector.z) < friction):
		speed_vector.z = 0
	#player.set_rotation(Vector3(PI / 2, 0, PI))
	player.translate(speed_vector * delta)
	primary_fire_cooldown -= delta
	if (Input.is_action_pressed("player_fire_primary") && primary_fire_cooldown <= 0):
		primary_fire_cooldown = 0.1
		var bullet = bullet_scene.instance()
		bullet.velocity = Vector3(0,20,0)
		get_tree().get_root().add_child(bullet)
		bullet.set_transform(player.get_global_transform())
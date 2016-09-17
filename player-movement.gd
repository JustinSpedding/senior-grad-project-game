extends Node

var speed = 2
var acceleration = .5
var friction = .25
var primary_fire_cooldown = 0
var bullet_scene = load("res://bullet-scene.tscn")
var vertical_speed = 0
var horizontal_speed = 0

func _ready():
	set_process(true)

func _process(delta):
	var cube = get_node("player")
	var location = cube.get_transform()
	get_node("player").translate(Vector3(horizontal_speed * delta, 0, vertical_speed * delta))
	
	if (Input.is_action_pressed("ui_down") and vertical_speed < speed):
		vertical_speed += acceleration
	if (Input.is_action_pressed("ui_up") and vertical_speed > -speed):
		vertical_speed -= acceleration
	if (Input.is_action_pressed("ui_left") and horizontal_speed < speed):
		horizontal_speed += acceleration
	if (Input.is_action_pressed("ui_right") and horizontal_speed > -speed):
		horizontal_speed -= acceleration
	if (vertical_speed > 0):
		vertical_speed -= friction
	elif (vertical_speed < 0):
		vertical_speed += friction
	if (horizontal_speed > 0):
		horizontal_speed -= friction
	elif (horizontal_speed < 0):
		horizontal_speed += friction
	
	primary_fire_cooldown -= delta
	if (Input.is_action_pressed("player_fire_primary") && primary_fire_cooldown <= 0):
		primary_fire_cooldown = 0.1
		var bullet = bullet_scene.instance()
		bullet.velocity = Vector3(0,20,0)
		get_tree().get_root().add_child(bullet)
		bullet.set_transform(cube.get_global_transform())
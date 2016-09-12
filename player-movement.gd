extends Node

var speed = 4
var primary_fire_cooldown = 0
var bullet_scene = load("res://bullet-scene.tscn")

func _ready():
	set_process(true)

func _process(delta):
	var cube = get_node("player")
	var location = cube.get_transform()
	
	var vertical_movement = 0
	var horizontal_movement = 0
	
	if (Input.is_action_pressed("ui_up")):
		vertical_movement += delta*speed
	if (Input.is_action_pressed("ui_down")):
		vertical_movement -= delta*speed
	if (Input.is_action_pressed("ui_right")):
		horizontal_movement += delta*speed
	if (Input.is_action_pressed("ui_left")):
		horizontal_movement -= delta*speed
	
	location.origin += Vector3(horizontal_movement,vertical_movement,0)
	cube.set_transform(location)
	
	primary_fire_cooldown -= delta
	if (Input.is_action_pressed("player_fire_primary") && primary_fire_cooldown <= 0):
		primary_fire_cooldown = 0.1
		var bullet = bullet_scene.instance()
		bullet.velocity = Vector3(0,20,0)
		get_tree().get_root().add_child(bullet)
		bullet.set_transform(cube.get_global_transform())
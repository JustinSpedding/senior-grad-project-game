
extends Spatial

var rambot_scene = load("res://enemies/rambot9001/rambot9001.tscn")

var rambot_spawn_rate = 5
var rambot_spawn_time_remaining = 0

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var player_scene = get_node("player_scene")
	player_scene.translate(Vector3(0, 0, -delta))
	
	rambot_spawn_time_remaining -= delta
	if rambot_spawn_time_remaining <= 0:
		create_rambot()
		rambot_spawn_time_remaining = rambot_spawn_rate

func create_rambot():
	var player_scene = get_node("player_scene")
	var player = player_scene.get_node("player")
	var rambot = rambot_scene.instance()
	rambot.setTarget(player)
	rambot.translate(Vector3(0, 0, -1000))
	player_scene.add_child(rambot)
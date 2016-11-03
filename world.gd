
extends Spatial

var rambot_scene = load("res://enemies/rambot9001/rambot9001.tscn")

func _ready():
	create_rambot()
	set_fixed_process(true)

func _fixed_process(delta):
	var player_scene = get_node("player_scene")
	player_scene.translate(Vector3(0, 0, -delta))

func create_rambot():
	var player_scene = get_node("player_scene")
	var player = player_scene.get_node("player")
	var rambot = rambot_scene.instance()
	rambot.setTarget(player)
	rambot.translate(Vector3(0, 0, -1000))
	player_scene.add_child(rambot)
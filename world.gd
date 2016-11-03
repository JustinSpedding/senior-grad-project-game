
extends Spatial

var rambot_scene = load("res://enemies/rambot9001/rambot9001.tscn");

func _ready():
	create_rambot()
	set_fixed_process(true);

func _fixed_process(delta):
	pass;

func create_rambot():
	var player = get_node("player_scene").get_node("player");
	var rambot = rambot_scene.instance();
	rambot.setTarget(player);
	rambot.translate(Vector3(0, 0, -1000));
	add_child(rambot);
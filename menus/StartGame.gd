extends Button

var scene;

func _ready():
	scene = preload("res://world_scene.tscn");
	pass

func _on_PlayGame_pressed():
	get_tree().change_scene_to(scene);
extends Button

var scene;

func _ready() -> void:
	scene = preload("res://world_scene.tscn")
	pass

func _on_PlayGame_pressed() -> void:
	get_tree().change_scene_to(scene)

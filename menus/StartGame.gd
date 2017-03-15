extends Button

func _ready():
	pass

func _on_PlayGame_pressed():
	get_tree().change_scene("res://world_scene.tscn")

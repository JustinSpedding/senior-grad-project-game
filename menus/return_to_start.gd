extends Button

func _ready():
	pass

func _on_return_pressed():
	get_tree().change_scene("res://menus/StartMenu.tscn")

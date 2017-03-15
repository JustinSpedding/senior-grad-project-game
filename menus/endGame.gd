extends Button

func _ready():
	pass

func _on_toMenu_pressed():
	get_tree().change_scene("res://menus/StartMenu.tscn")

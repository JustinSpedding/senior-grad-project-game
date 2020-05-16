extends Button

func _ready() -> void:
	pass

func _on_return_pressed() -> void:
	get_tree().change_scene("res://menus/start_menu.tscn")

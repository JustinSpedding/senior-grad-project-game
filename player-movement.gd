extends Node

var speed = 4

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
extends Node

var time = 0

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	time += delta
	if time > 0.5:
		queue_free()
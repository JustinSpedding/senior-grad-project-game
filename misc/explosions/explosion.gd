extends Node

class_name Explosion

const time_to_live: float = 0.25
var time: float = 0.0

func _ready() -> void:
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	time += delta
	if time > time_to_live:
		queue_free()

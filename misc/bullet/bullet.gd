
extends KinematicBody

var speed = 0
var damage = 200
var time_to_live = 3

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	move(Vector3(0, 0, -speed)*delta)
	
	if is_colliding() and get_collider().is_in_group("enemies"):
		get_collider().health -= damage
		queue_free()
	
	time_to_live -= delta
	if (time_to_live <= 0):
		queue_free()
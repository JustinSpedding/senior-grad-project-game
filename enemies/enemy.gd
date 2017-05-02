extends KinematicBody

var explosion_scene = load("res://misc/explosions/explosion.tscn")

func explode():
	var explosion = explosion_scene.instance()
	get_parent().add_child(explosion)
	explosion.translate(get_translation())
	queue_free()

func is_close_enough(point1, point2, distance):
	var diff = (point1 - point2).abs()
	return diff.x <= distance && diff.y <= distance && diff.z <= distance
extends KinematicBody

class_name Enemy

var explosion_scene: PackedScene = load("res://misc/explosions/explosion_scene_enemy.tscn")

var target: Node
var health: int = 2000
var state: int

func explode() -> void:
	var explosion: Explosion = explosion_scene.instance()
	get_parent().add_child(explosion)
	explosion.translate(get_translation())
	queue_free()

func is_close_enough(point1: Vector3, point2: Vector3, distance: float) -> bool:
	var diff: Vector3 = (point1 - point2).abs()
	return diff.x <= distance && diff.y <= distance && diff.z <= distance

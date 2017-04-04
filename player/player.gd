
extends KinematicBody

var bullet_scene = load("res://misc/bullet/bullet.tscn")

const crosshair_speed = 1000
const player_speed = 2
const x_bound = 3
const y_bound = 1.5

const primary_fire_cooldown = 0.1
const primary_fire_bullet_speed = 20
const primary_fire_damage = 200

var health = 5000
var speed_vector = Vector2(0, 0)
var primary_fire_time_remaining = 0

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func _fixed_process(delta):
	# Set health text in HUD
	var health_text = get_tree().get_root().get_node("world").get_node("hud").get_node("health_text")
	health_text.clear()
	health_text.add_text("Health: " + str(health))
	
	# End game if player runs out of health
	if (health <= 0):
		get_tree().change_scene("res://menus/GameOver.tscn")
	
	# Move crosshair
	var crosshair = get_parent().get_node("crosshair")
	var velocity = Vector2(0, 0)
	if (Input.is_action_pressed("ui_down")):
		velocity += Vector2(0, 1)
	if (Input.is_action_pressed("ui_up")):
		velocity -= Vector2(0, 1)
	if (Input.is_action_pressed("ui_left")):
		velocity -= Vector2(1, 0)
	if (Input.is_action_pressed("ui_right")):
		velocity += Vector2(1, 0)
	crosshair.set_global_pos(crosshair.get_global_pos() + (velocity.normalized()*crosshair_speed*delta))
	
	# Keep crosshair within bounds
	if (crosshair.get_global_pos().x > 907):
		crosshair.set_global_pos(Vector2(907, crosshair.get_global_pos().y))
	if (crosshair.get_global_pos().x < -117):
		crosshair.set_global_pos(Vector2(-117, crosshair.get_global_pos().y))
	if (crosshair.get_global_pos().y > 483):
		crosshair.set_global_pos(Vector2(crosshair.get_global_pos().x, 483))
	if (crosshair.get_global_pos().y < -117):
		crosshair.set_global_pos(Vector2(crosshair.get_global_pos().x, -117))
	
	# Move player closer to crosshair
	var player_location = get_transform().origin
	player_location.z = 0
	var target = Vector3((crosshair.get_global_pos().x-395)*0.006, (crosshair.get_global_pos().y-183)*-0.006, 0)
	translate((target - player_location) * player_speed * delta)
	
	# Fire weapons
	primary_fire_time_remaining -= delta
	if (Input.is_action_pressed("player_fire_primary") && primary_fire_time_remaining <= 0):
		primary_fire_time_remaining = primary_fire_cooldown
		var bullet = bullet_scene.instance()
		bullet.speed = primary_fire_bullet_speed
		bullet.damage = primary_fire_damage
		bullet.target_group = "damageable"
		bullet.target_ref = get_target()
		get_parent().get_parent().add_child(bullet)
		bullet.set_transform(get_global_transform())

func get_target():
	# Get ray location and direction
	var camera = get_parent().get_node("camera")
	var aim_position = get_parent().get_node("crosshair").get_global_pos() + Vector2(117,117)
	var ray_origin = camera.project_ray_origin(aim_position)
	var ray_direction = camera.project_ray_normal(aim_position)

	# Cast ray
	var from = ray_origin
	var to = ray_origin + ray_direction * 1000.0
	var space_state = get_world().get_direct_space_state()
	var hit = space_state.intersect_ray(from, to, [get_parent().get_node("player")])
	
	# Return first hit if any
	if (hit.size() != 0):
		print("has target")
		return weakref(hit.collider)
	else:
		return null

func _input(event):
	if event.type == InputEvent.MOUSE_MOTION:
		get_parent().get_node("crosshair").set_global_pos(get_viewport().get_mouse_pos() - Vector2(117,117))
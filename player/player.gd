
extends KinematicBody

var projectile_scene = load("res://misc/projectiles/bullet.tscn")

const crosshair_speed = 50
const crosshair_x_upper_bound = 15
const crosshair_x_lower_bound = -15
const crosshair_y_upper_bound = 3
const crosshair_y_lower_bound = -15

const player_speed = 5
const player_x_upper_bound = 3
const player_x_lower_bound = -3
const player_y_upper_bound = 2
const player_y_lower_bound = -2

const primary_fire_cooldown = 0.01
const primary_fire_speed = 40
const primary_fire_damage = 100
const primary_fire_spawn_offset = Vector3(0.4, 0, 0)

var health = 5000
var speed_vector = Vector2(0, 0)
var primary_fire_time_remaining = 0

var game_ended = false

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func _fixed_process(delta):
	# If game already endes, do nothing
	if game_ended:
		return
	
	# End game if song ends
	if !get_parent().get_parent().get_node("song").is_playing():
		game_ended = true
		set_translation(Vector3(0,0,0))
		get_parent().get_node("end_animation").play("camera rotate")
		get_parent().get_node("crosshair").set_hidden(true)
		get_parent().get_node("return").set_hidden(false)
		get_parent().get_node("win_text").set_hidden(false)
		get_tree().call_group(0, "enemy", "explode")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# End game if player runs out of health
	if health <= 0:
		game_ended = true
		get_parent().get_node("end_animation").play("zoom camera out")
		get_parent().get_node("player_explosion").set_emitting(true)
		get_parent().get_node("crosshair").set_hidden(true)
		get_parent().get_node("return").set_hidden(false)
		get_parent().get_node("gameover_text").set_hidden(false)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Set health text in HUD
	var health_text = get_tree().get_root().get_node("world").get_node("hud").get_node("health_text")
	health_text.clear()
	health_text.add_text("Health: " + str(health))
	
	# Move crosshair
	var crosshair = get_parent().get_node("crosshair")
	var crosshair_velocity = Vector3(0, 0, 0)
	if (Input.is_action_pressed("aim_down")):
		crosshair_velocity -= Vector3(0, 1, 0)
	if (Input.is_action_pressed("aim_up")):
		crosshair_velocity += Vector3(0, 1, 0)
	if (Input.is_action_pressed("aim_left")):
		crosshair_velocity -= Vector3(1, 0, 0)
	if (Input.is_action_pressed("aim_right")):
		crosshair_velocity += Vector3(1, 0, 0)
	crosshair_velocity = crosshair_velocity.normalized()*crosshair_speed*delta
	crosshair.translate(crosshair_velocity)
	
	# Keep crosshair within bounds
	var crosshair_location = crosshair.get_translation()
	if (crosshair_location.x > crosshair_x_upper_bound):
		crosshair_location.x = crosshair_x_upper_bound
	if (crosshair_location.x < crosshair_x_lower_bound):
		crosshair_location.x = crosshair_x_lower_bound
	if (crosshair_location.y > crosshair_y_upper_bound):
		crosshair_location.y = crosshair_y_upper_bound
	if (crosshair_location.y < crosshair_y_lower_bound):
		crosshair_location.y = crosshair_y_lower_bound
	crosshair.set_translation(crosshair_location)
	
	# Move player
	var player_velocity = Vector3(0, 0, 0)
	if (Input.is_action_pressed("move_down")):
		player_velocity -= Vector3(0, 1, 0)
	if (Input.is_action_pressed("move_up")):
		player_velocity += Vector3(0, 1, 0)
	if (Input.is_action_pressed("move_left")):
		player_velocity -= Vector3(1, 0, 0)
	if (Input.is_action_pressed("move_right")):
		player_velocity += Vector3(1, 0, 0)
	player_velocity = player_velocity.normalized()*player_speed*delta
	translate(player_velocity)
	
	# Keep player within bounds
	var player_location = get_translation()
	if (player_location.x > player_x_upper_bound):
		player_location.x = player_x_upper_bound
	if (player_location.x < player_x_lower_bound):
		player_location.x = player_x_lower_bound
	if (player_location.y > player_y_upper_bound):
		player_location.y = player_y_upper_bound
	if (player_location.y < player_y_lower_bound):
		player_location.y = player_y_lower_bound
	set_translation(player_location)
	
	# Fire weapons
	primary_fire_time_remaining -= delta
	if (Input.is_action_pressed("player_fire_primary") && primary_fire_time_remaining <= 0):
		primary_fire_time_remaining = primary_fire_cooldown
		var projectile = projectile_scene.instance()
		projectile.speed = primary_fire_speed
		projectile.damage = primary_fire_damage
		projectile.target_group = "damageable"
		projectile.target_ref = get_target()
		get_parent().get_parent().add_child(projectile)
		projectile.set_transform(get_global_transform())
		projectile.translate(primary_fire_spawn_offset)
		primary_fire_spawn_offset *= -1
		projectile.look_at(get_parent().get_node("crosshair").get_global_transform().origin, Vector3(0,1,0))

func get_target():
	# Cast a ray
	var camera = get_parent().get_node("camera")
	var crosshair_position = camera.unproject_position(get_parent().get_node("crosshair").get_global_transform().origin)
	var from = camera.project_ray_origin(crosshair_position)
	var to = from + camera.project_ray_normal(crosshair_position) * 1000.0
	var hit = get_world().get_direct_space_state().intersect_ray(from, to, [get_parent().get_node("player")])
	
	# Return first hit if any
	if (hit.size() != 0):
		return weakref(hit.collider)
	else:
		return null

func _input(event):
	if event.type == InputEvent.MOUSE_MOTION:
		var mouse_pos = get_viewport().get_mouse_pos() - Vector2(512,200)
		var crosshair = get_parent().get_node("crosshair")
		var new_location = crosshair.get_translation()
		new_location.x = mouse_pos.x * 0.03
		new_location.y = (mouse_pos.y * -0.032) - 2
		crosshair.set_translation(new_location)
extends KinematicBody

class_name Player

var projectile_scene: PackedScene = load("res://misc/projectiles/bullet.tscn")

const crosshair_speed: float = 10.0
const crosshair_x_upper_bound: float = 15.0
const crosshair_x_lower_bound: float = -15.0
const crosshair_y_upper_bound: float = 3.0
const crosshair_y_lower_bound: float = -15.0

const player_speed: float = 5.0
const player_x_upper_bound: float = 3.0
const player_x_lower_bound: float = -3.0
const player_y_upper_bound: float = 2.0
const player_y_lower_bound: float = -2.0

const primary_fire_cooldown: float = 0.01
const primary_fire_speed: float = 40.0
const primary_fire_damage: int = 100

var health: int = 5000
var speed_vector: Vector2 = Vector2(0.0, 0.0)
var primary_fire_time_remaining: float = 0.0
var primary_fire_spawn_offset: Vector3 = Vector3(0.4, 0.0, 0.0)

var game_ended: bool = false

func _ready() -> void:
	set_physics_process(true)
	set_process_input(true)

func _physics_process(delta: float) -> void:
	# If game already endes, do nothing
	if game_ended:
		return
	
	# End game if song ends
	if !get_parent().get_parent().get_node("song").is_playing():
		game_ended = true
		set_translation(Vector3(0.0, 0.0, 0.0))
		get_parent().get_node("end_animation").play("camera rotate")
		get_parent().get_node("crosshair").visible = false
		get_parent().get_node("return").visible = true
		get_parent().get_node("win_text").visible = true
		get_tree().call_group("enemy", "explode")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# End game if player runs out of health
	if health <= 0:
		health = 0
		game_ended = true
		get_node("player_model").visible = false
		get_node("engine_trail_left").set_emitting(false)
		get_node("engine_trail_right").set_emitting(false)
		get_parent().get_node("end_animation").play("zoom camera out")
		get_parent().get_node("player_explosion").set_emitting(true)
		get_parent().get_node("crosshair").visible = false
		get_parent().get_node("return").visible = true
		get_parent().get_node("gameover_text").visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Set health text in HUD
	var health_text: RichTextLabel = get_tree().get_root().get_node("world").get_node("hud").get_node("health_text")
	health_text.clear()
	health_text.add_text("Health: " + str(health))
	
	# Move crosshair
	var crosshair: Node = get_parent().get_node("crosshair")
	var crosshair_velocity: Vector3 = Vector3(0.0, 0.0, 0.0)
	if (Input.is_action_pressed("aim_down")):
		crosshair_velocity -= Vector3(0.0, 1.0, 0.0)
	if (Input.is_action_pressed("aim_up")):
		crosshair_velocity += Vector3(0.0, 1.0, 0.0)
	if (Input.is_action_pressed("aim_left")):
		crosshair_velocity -= Vector3(1.0, 0.0, 0.0)
	if (Input.is_action_pressed("aim_right")):
		crosshair_velocity += Vector3(1.0, 0.0, 0.0)
	crosshair_velocity = crosshair_velocity.normalized() * (crosshair_speed * delta)
	crosshair.translate(crosshair_velocity)
	
	# Keep crosshair within bounds
	var crosshair_location: Vector3 = crosshair.get_translation()
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
	var player_velocity: Vector3 = Vector3(0.0, 0.0, 0.0)
	if (Input.is_action_pressed("move_down")):
		player_velocity -= Vector3(0.0, 1.0, 0.0)
	if (Input.is_action_pressed("move_up")):
		player_velocity += Vector3(0.0, 1.0, 0.0)
	if (Input.is_action_pressed("move_left")):
		player_velocity -= Vector3(1.0, 0.0, 0.0)
	if (Input.is_action_pressed("move_right")):
		player_velocity += Vector3(1.0, 0.0, 0.0)
	player_velocity = player_velocity.normalized() * (player_speed * delta)
	translate(player_velocity)
	
	# Keep player within bounds
	var player_location: Vector3 = get_translation()
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
	if (Input.is_action_pressed("player_fire_primary") && primary_fire_time_remaining <= 0.0):
		primary_fire_time_remaining = primary_fire_cooldown
		var projectile: Projectile = projectile_scene.instance()
		projectile.speed = primary_fire_speed
		projectile.damage = primary_fire_damage
		projectile.target_group = "damageable"
		projectile.target_ref = get_target()
		get_parent().get_parent().add_child(projectile)
		projectile.set_transform(get_global_transform())
		projectile.translate(primary_fire_spawn_offset)
		primary_fire_spawn_offset.x *= -1
		projectile.look_at(get_parent().get_node("crosshair").get_global_transform().origin, Vector3(0.0, 1.0, 0.0))

func get_target() -> WeakRef:
	# Cast a ray
	var camera: Camera = get_parent().get_node("camera")
	var crosshair_position: Vector2 = camera.unproject_position(get_parent().get_node("crosshair").get_global_transform().origin)
	var from: Vector3 = camera.project_ray_origin(crosshair_position)
	var to: Vector3 = from + camera.project_ray_normal(crosshair_position) * 1000.0
	var hit: Dictionary = get_world().get_direct_space_state().intersect_ray(from, to, [get_parent().get_node("player")])
	
	# Return first hit if any
	if (hit.size() > 0):
		return weakref(hit.collider)
	else:
		return null

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_pos: Vector2 = get_viewport().get_mouse_position() - Vector2(512.0, 200.0)
		var crosshair: Node = get_parent().get_node("crosshair")
		var new_location: Vector3 = crosshair.get_translation()
		new_location.x = mouse_pos.x * 0.03
		new_location.y = (mouse_pos.y * -0.032) - 2.0
		crosshair.set_translation(new_location)

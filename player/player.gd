
extends KinematicBody

var bullet_scene = load("res://misc/bullet/bullet.tscn")

const max_speed = 10
const friction = .5
const acceleration_magnitude = 1
const x_bound = 3
const y_bound = 1.5

const primary_fire_cooldown = 0.1
const primary_fire_bullet_speed = 20
const primary_fire_damage = 200

var health = 5000
var speed_vector = Vector3(0, 0, 0)
var primary_fire_time_remaining = 0

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	# Set health test in HUD
	var health_text = get_tree().get_root().get_node("world").get_node("hud").get_node("health_text")
	health_text.clear()
	health_text.add_text("Health: " + str(health))
	
	#end game if player runs out of health
	if (health <= 0):
		get_tree().change_scene("res://menus/GameOver.tscn")
	
	# Move player
	var acceleration = Vector3(0, 0, 0)
	if (Input.is_action_pressed("ui_down")):
		acceleration -= Vector3(0, 1, 0)
	if (Input.is_action_pressed("ui_up")):
		acceleration += Vector3(0, 1, 0)
	if (Input.is_action_pressed("ui_left")):
		acceleration -= Vector3(1, 0, 0)
	if (Input.is_action_pressed("ui_right")):
		acceleration += Vector3(1, 0, 0)
	acceleration = acceleration.normalized() * acceleration_magnitude
	var friction_vector = speed_vector.normalized() * friction
	speed_vector += acceleration - friction_vector
	if (speed_vector.length() > max_speed):
		speed_vector = speed_vector.normalized() * max_speed
	if (abs(speed_vector.x) < friction):
		speed_vector.x = 0
	if (abs(speed_vector.y) < friction):
		speed_vector.y = 0
	translate(speed_vector * delta)
	
	# Do not let player leave observable area
	var new_location = get_global_transform().origin
	if (new_location.x > x_bound):
		new_location.x = x_bound
	if (new_location.x < -x_bound):
		new_location.x = -x_bound
	if (new_location.y > y_bound):
		new_location.y = y_bound
	if (new_location.y < -y_bound):
		new_location.y = -y_bound
	new_location.z = 0
	set_translation(new_location)
	
	# Fire weapons
	primary_fire_time_remaining -= delta
	if (Input.is_action_pressed("player_fire_primary") && primary_fire_time_remaining <= 0):
		primary_fire_time_remaining = primary_fire_cooldown
		var bullet = bullet_scene.instance()
		bullet.speed = primary_fire_bullet_speed
		bullet.damage = primary_fire_damage
		bullet.target_group = "damageable"
		get_parent().get_parent().add_child(bullet)
		bullet.set_transform(get_global_transform())

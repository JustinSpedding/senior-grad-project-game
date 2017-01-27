
extends Spatial

var rambot_scene = load("res://enemies/rambot9001/rambot9001.tscn")
var shooter_scene = load("res://enemies/shooter/shooter.tscn")
var kamikaze_scene = load("res://enemies/kamikaze/kamikaze.tscn")
var sniper_scene = load("res://enemies/sniper/Sniper.tscn")
var rocketeer_scene = load("res://enemies/rocketeer/rocketeer.tscn")

var rambot_spawn_rate = 5
var rambot_spawn_time_remaining = 0
var shooter_spawn_rate = 5
var shooter_spawn_time_remaining = 0
var shooter_attack_rate = 1
var shooter_attack_time_remaining = 0
var kamikaze_spawn_rate = 5
var kamikaze_spawn_time_remaining = 0
var sniper_spawn_rate = 5
var sniper_spawn_time_remaining = 0
var sniper_attack_rate = 1
var sniper_attack_time_remaining = 0
var rocketeer_spawn_rate = 5
var rocketeer_spawn_time_remaining = 0
var rocketeer_attack_rate = 1
var rocketeer_attack_time_remaining = 0


func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var player_scene = get_node("player_scene")
	player_scene.translate(Vector3(0, 0, -delta))
	
	rambot_spawn_time_remaining -= delta
	if rambot_spawn_time_remaining <= 0:
		create_enemy(rambot_scene)
		rambot_spawn_time_remaining = rambot_spawn_rate
	
	shooter_spawn_time_remaining -= delta
	if shooter_spawn_time_remaining <= 0:
		create_enemy(shooter_scene)
		shooter_spawn_time_remaining = shooter_spawn_rate
	
	shooter_attack_time_remaining -= delta
	if shooter_attack_time_remaining <= 0:
		get_tree().call_group(0, "shooter", "shoot")
		shooter_attack_time_remaining = shooter_attack_rate
		
	sniper_spawn_time_remaining -= delta
	if sniper_spawn_time_remaining <= 0:
		create_enemy(sniper_scene)
		sniper_spawn_time_remaining = sniper_spawn_rate
	
	sniper_attack_time_remaining -= delta
	if sniper_attack_time_remaining <= 0:
		get_tree().call_group(0, "sniper", "shoot")
		sniper_attack_time_remaining = shooter_attack_rate
		
	rocketeer_spawn_time_remaining -= delta
	if rocketeer_spawn_time_remaining <= 0:
		create_enemy(rocketeer_scene)
		rocketeer_spawn_time_remaining = rocketeer_spawn_rate
	
	rocketeer_attack_time_remaining -= delta
	if rocketeer_attack_time_remaining <= 0:
		get_tree().call_group(0, "rocketeer", "shoot")
		rocketeer_attack_time_remaining = rocketeer_attack_rate
	
	kamikaze_spawn_time_remaining -= delta
	if kamikaze_spawn_time_remaining <= 0:
		create_enemy(kamikaze_scene)
		kamikaze_spawn_time_remaining = kamikaze_spawn_rate

func create_enemy(enemy_scene):
	var player_scene = get_node("player_scene")
	var player = player_scene.get_node("player")
	var enemy = enemy_scene.instance()
	enemy.target = player
	enemy.translate(Vector3(0, 0, -100))
	player_scene.add_child(enemy)
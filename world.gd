
extends Spatial

var rambot_scene = load("res://enemies/rambot9001/rambot9001.tscn")
var shooter_scene = load("res://enemies/shooter/shooter.tscn")
var kamikaze_scene = load("res://enemies/kamikaze/kamikaze.tscn")
var sniper_scene = load("res://enemies/sniper/Sniper.tscn")
var rocketeer_scene = load("res://enemies/rocketeer/rocketeer.tscn")

var rambot_spawn_number = "0"
var kamikaze_spawn_number = "1"
var shooter_spawn_number = "2"
var sniper_spawn_number = "3"
var rocketeer_spawn_number = "4"
var shooter_attack_number = "5"
var rocketeer_attack_number = "6"
var sniper_attack_number = "7"

var data = {}
var rambot_spawn_time = 0
var shooter_spawn_time = 0
var shooter_attack_time = 0
var kamikaze_spawn_time = 0
var sniper_spawn_time = 0
var sniper_attack_time = 0
var rocketeer_spawn_time = 0
var rocketeer_attack_time = 0
var time = 0

func _ready():
	var file = File.new()
	file.open("./data.txt", file.READ)
	data.parse_json(file.get_as_text())
	rambot_spawn_time = get_next_time(data, rambot_spawn_number)
	kamikaze_spawn_time = get_next_time(data, kamikaze_spawn_number)
	shooter_spawn_time = get_next_time(data, shooter_spawn_number)
	sniper_spawn_time = get_next_time(data, sniper_spawn_number)
	rocketeer_spawn_time = get_next_time(data, rocketeer_spawn_number)
	shooter_attack_time = get_next_time(data, shooter_attack_number)
	sniper_attack_time = get_next_time(data, sniper_attack_number)
	rocketeer_attack_time = get_next_time(data, rocketeer_attack_number)
	file.close()
	get_node("SamplePlayer").play("anime")
	set_fixed_process(true)

func _fixed_process(delta):
	var player_scene = get_node("player_scene")
	player_scene.translate(Vector3(0, 0, -delta))
	
	
	time += delta
	if rambot_spawn_time <= time:
		create_enemy(rambot_scene)
		rambot_spawn_time = get_next_time(data, rambot_spawn_number)
	
	if kamikaze_spawn_time <= time:
		create_enemy(kamikaze_scene)
		kamikaze_spawn_time = get_next_time(data, kamikaze_spawn_number)
	
	if shooter_spawn_time <= time:
		create_enemy(shooter_scene)
		shooter_spawn_time = get_next_time(data, shooter_spawn_number)
	
	if sniper_spawn_time <= time:
		create_enemy(sniper_scene)
		sniper_spawn_time = get_next_time(data, sniper_spawn_number)
	
	if rocketeer_spawn_time <= time:
		create_enemy(rocketeer_scene)
		rocketeer_spawn_time = get_next_time(data, rocketeer_spawn_number)
	
	if shooter_attack_time <= time:
		get_tree().call_group(0, "shooter", "shoot")
		shooter_attack_time = get_next_time(data, shooter_attack_number)
	
	if sniper_attack_time <= time:
		get_tree().call_group(0, "sniper", "shoot")
		sniper_attack_time = get_next_time(data, sniper_attack_number)
	
	if rocketeer_attack_time <= time:
		get_tree().call_group(0, "rocketeer", "shoot")
		rocketeer_attack_time = get_next_time(data, rocketeer_attack_number)

func get_next_time(data, number):
	var time = 999999999
	if data[number].size() > 0:
		time = data[number][0]
		data[number].remove(0)
	return time

func create_enemy(enemy_scene):
	var player_scene = get_node("player_scene")
	var player = player_scene.get_node("player")
	var enemy = enemy_scene.instance()
	enemy.target = player
	enemy.translate(Vector3(0, 0, -100))
	player_scene.add_child(enemy)

extends WorldEnvironment

var rambot_scene = load("res://enemies/rambot9001/rambot9001.tscn")
var shooter_scene = load("res://enemies/shooter/shooter.tscn")
var kamikaze_scene = load("res://enemies/kamikaze/kamikaze.tscn")
var sniper_scene = load("res://enemies/sniper/sniper.tscn")
var rocketeer_scene = load("res://enemies/rocketeer/rocketeer.tscn")
var enemy_material = load("res://misc/materials/enemy_material.tres")

var rambot_spawn_number = "0"
var kamikaze_spawn_number = "1"
var shooter_spawn_number = "4"
var sniper_spawn_number = "3"
var rocketeer_spawn_number = "2"
var shooter_attack_number = "6"
var rocketeer_attack_number = "5"
var sniper_attack_number = "7"

var data: Dictionary = {}
var rambot_spawn_time: float = 0
var shooter_spawn_time: float = 0
var shooter_attack_time: float = 0
var kamikaze_spawn_time: float = 0
var sniper_spawn_time: float = 0
var sniper_attack_time: float = 0
var rocketeer_spawn_time: float = 0
var rocketeer_attack_time: float = 0
var time: float = 0

var music_speed: float = 0.0
var music_speed_min: float = -10.0
var music_speed_max: float = 10.0
var music_speed_step: float = 4.0
var music_speed_decay: float = 10.0

func swap(list: Array, i: int, j: int) -> void:
	var temp = list[i]
	list[i] = list[j]
	list[j] = temp

func get_sorted() -> Array:
	var container = [data["0"], data["1"], data["2"], data["3"], data["4"], data["5"], data["6"], data["7"]]
	var freq = []
	var order = ["0", "1", "2", "3", "4", "5", "6", "7"]
	for i in container:
		freq.append(i.size())
	for i in range(freq.size()):
		for j in range(freq.size() - i):
			if freq[i] < freq[j + i]:
				swap(freq, i, j + i)
				swap(order, i, j + i)
	return order
	
func _ready() -> void:
	var file = File.new()
	file.open("./data.txt", file.READ)
	data = parse_json(file.get_as_text())
	
	var rel_frequency: Array = get_sorted()
	shooter_attack_number = rel_frequency[0]
	rocketeer_attack_number = rel_frequency[1]
	shooter_spawn_number = rel_frequency[2]
	rocketeer_spawn_number = rel_frequency[3]
	rambot_spawn_number = rel_frequency[4]
	kamikaze_spawn_number = rel_frequency[5]
	sniper_spawn_number = rel_frequency[6]
	sniper_attack_number = rel_frequency[7]
	
	rambot_spawn_time = get_next_time(rambot_spawn_number)
	kamikaze_spawn_time = get_next_time(kamikaze_spawn_number)
	shooter_spawn_time = get_next_time(shooter_spawn_number)
	sniper_spawn_time = get_next_time(sniper_spawn_number)
	rocketeer_spawn_time = get_next_time(rocketeer_spawn_number)
	shooter_attack_time = get_next_time(shooter_attack_number)
	sniper_attack_time = get_next_time(sniper_attack_number)
	rocketeer_attack_time = get_next_time(rocketeer_attack_number)
	file.close()

	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if get_node("player_scene").get_node("player").game_ended:
		return
	
	var player_scene: Node = get_node("player_scene")
	player_scene.translate(Vector3(0.0, 0.0, -delta))
	time += delta
	music_speed -= music_speed_decay * delta
	
	if rambot_spawn_time <= time:
		create_enemy(rambot_scene)
		rambot_spawn_time = get_next_time(rambot_spawn_number)
		music_speed += music_speed_step
	
	if kamikaze_spawn_time <= time:
		create_enemy(kamikaze_scene)
		kamikaze_spawn_time = get_next_time(kamikaze_spawn_number)
		music_speed += music_speed_step
	
	if shooter_spawn_time <= time:
		create_enemy(shooter_scene)
		if get_tree().get_nodes_in_group("shooter").size() > 5:
			get_tree().call_group("shooter", "shoot")
		shooter_spawn_time = get_next_time(shooter_spawn_number)
		music_speed += music_speed_step
	
	if sniper_spawn_time <= time:
		create_enemy(sniper_scene)
		if get_tree().get_nodes_in_group("sniper").size() > 5:
			get_tree().call_group("sniper", "shoot")
		sniper_spawn_time = get_next_time(sniper_spawn_number)
		music_speed += music_speed_step
	
	if rocketeer_spawn_time <= time:
		create_enemy(rocketeer_scene)
		if get_tree().get_nodes_in_group("rockeer").size() > 5:
			get_tree().call_group("rocketeer", "shoot")
		rocketeer_spawn_time = get_next_time(rocketeer_spawn_number)
		music_speed += music_speed_step
	
	if shooter_attack_time <= time:
		get_tree().call_group("shooter", "shoot")
		if (get_tree().get_nodes_in_group("shooter").size() < 5):
			create_enemy(shooter_scene)
		shooter_attack_time = get_next_time(shooter_attack_number)
		music_speed += music_speed_step
	
	if sniper_attack_time <= time:
		get_tree().call_group("sniper", "shoot")
		if (get_tree().get_nodes_in_group("sniper").size() == 0):
			create_enemy(sniper_scene)
		sniper_attack_time = get_next_time(sniper_attack_number)
		music_speed += music_speed_step
	
	if rocketeer_attack_time <= time:
		get_tree().call_group("rocketeer", "shoot")
		if (get_tree().get_nodes_in_group("rocketeer").size() < 3):
			create_enemy(rocketeer_scene)
		rocketeer_attack_time = get_next_time(rocketeer_attack_number)
		music_speed += music_speed_step
	
	if music_speed < music_speed_min:
		music_speed = music_speed_min
	if music_speed > music_speed_max:
		music_speed = music_speed_max
	
	var speed_ratio = music_speed/music_speed_max
	enemy_material.albedo_color = Color(red(speed_ratio), green(speed_ratio), blue(speed_ratio), 0.5)

func red(ratio: float) -> float:
	if ratio > 0:
		return ratio
	else:
		return 0.0

func green(ratio: float) -> float:
	return 1 - abs(ratio)

func blue(ratio: float) -> float:
	if ratio > 0:
		return 0.0
	else:
		return -ratio

func get_next_time(event_number: String) -> float:
	var next_time: float = 999999999
	if data[event_number].size() > 0:
		next_time = float(data[event_number].pop_front())
	return next_time

func create_enemy(enemy_scene: PackedScene):
	var player_scene: Node = get_node("player_scene")
	var player: Node = player_scene.get_node("player")
	var enemy: Enemy = enemy_scene.instance()
	enemy.target = player
	enemy.translate(Vector3(rand_range(-40.0, 40.0), rand_range(-40.0, 30.0), -100.0))
	player_scene.add_child(enemy)


extends Spatial

var rambot_scene = load("res://enemies/rambot9001/rambot9001.tscn")
var shooter_scene = load("res://enemies/shooter/shooter.tscn")
var kamikaze_scene = load("res://enemies/kamikaze/kamikaze.tscn")
var sniper_scene = load("res://enemies/sniper/Sniper.tscn")
var rocketeer_scene = load("res://enemies/rocketeer/rocketeer.tscn")

var rambot_spawn_number = "0"
var kamikaze_spawn_number = "1"
var shooter_spawn_number = "4"
var sniper_spawn_number = "3"
var rocketeer_spawn_number = "2"
var shooter_attack_number = "6"
var rocketeer_attack_number = "5"
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

func swap(list, i, j):
	var temp = list[i]
	list[i] = list[j]
	list[j] = temp
	return list

func get_sorted(data):
	var container = [data["0"],data["1"],data["2"],data["3"],data["4"],data["5"],data["6"],data["7"]]
	var freq = []
	var order = ["0", "1", "2", "3", "4", "5", "6" , "7"]
	for i in container:
		freq.append(i.size())
	for i in range(freq.size()):
		for j in range(freq.size() - i):
			if freq[i] < freq[j + i]:
				freq = swap(freq, i, j + i)
				order = swap(order, i, j + i)
	return order
	
func _ready():
	var file = File.new()
	file.open("./data.txt", file.READ)
	data.parse_json(file.get_as_text())
	
	var rel_frequency = get_sorted(data)
	shooter_attack_number = rel_frequency[0]
	rocketeer_attack_number = rel_frequency[1]
	shooter_spawn_number = rel_frequency[2]
	rocketeer_attack_number = rel_frequency[3]
	rambot_spawn_number = rel_frequency[4]
	kamikaze_spawn_time = rel_frequency[5]
	sniper_spawn_time = rel_frequency[6]
	sniper_attack_time = rel_frequency[7]
	print(shooter_attack_number)
	
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

var queued = false

func _fixed_process(delta):
	var player_scene = get_node("player_scene")
	player_scene.translate(Vector3(0, 0, -delta))
	#if not queued:
	#	queued = true
	#	get_viewport().queue_screen_capture()
	#else:
	#	var image = get_viewport().get_screen_capture()
	#	if not image.empty():
	#		queued = false
	#		var path = "./ss/"
	#		path += str(time)
	#		path += ".png"
	#		image.save_png(path)
	time += delta
	if rambot_spawn_time <= time:
		print("rambot spawn")
		create_enemy(rambot_scene)
		rambot_spawn_time = get_next_time(data, rambot_spawn_number)
	
	if kamikaze_spawn_time <= time:
		print("kami spawn")
		create_enemy(kamikaze_scene)
		kamikaze_spawn_time = get_next_time(data, kamikaze_spawn_number)
	
	if shooter_spawn_time <= time:
		create_enemy(shooter_scene)
		print("shooter spawn")
		if get_tree().get_nodes_in_group("shooter").size() > 5:
			print("shooter shoot")
			get_tree().call_group(0, "shooter", "shoot")
		shooter_spawn_time = get_next_time(data, shooter_spawn_number)
	
	if sniper_spawn_time <= time:
		create_enemy(sniper_scene)
		print("sniper spawn")
		if get_tree().get_nodes_in_group("sniper").size() > 5:
			get_tree().call_group(0, "sniper", "shoot")
			print("sniper shoot")
		sniper_spawn_time = get_next_time(data, sniper_spawn_number)
	
	if rocketeer_spawn_time <= time:
		create_enemy(rocketeer_scene)
		print("rocket spawn")
		if get_tree().get_nodes_in_group("rockeer").size() > 5:
			get_tree().call_group(0, "rocketeer", "shoot")
			print("rocket shoot")
		rocketeer_spawn_time = get_next_time(data, rocketeer_spawn_number)
	
	if shooter_attack_time <= time:
		get_tree().call_group(0, "shooter", "shoot")
		print("shooter shoot")
		if (get_tree().get_nodes_in_group("shooter").size() < 3):
			create_enemy(shooter_scene)
			print("shooter spawn")
		shooter_attack_time = get_next_time(data, shooter_attack_number)
	
	if sniper_attack_time <= time:
		get_tree().call_group(0, "sniper", "shoot")
		print("sniper shoot")
		if (get_tree().get_nodes_in_group("sniper").size() == 0):
			create_enemy(sniper_scene)
			print("sniper spawn")
		sniper_attack_time = get_next_time(data, sniper_attack_number)
	
	if rocketeer_attack_time <= time:
		get_tree().call_group(0, "rocketeer", "shoot")
		print("rocketeer shoot")
		if (get_tree().get_nodes_in_group("rocketeer").size() < 2):
			create_enemy(rocketeer_scene)
			print("rocketeer spawn")
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
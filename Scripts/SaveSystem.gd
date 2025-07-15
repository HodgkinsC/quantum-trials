extends Node

var save_location = "user://"

var save_contents = []

func ready_save(savenum):
	save_location = "user://" + str(savenum) + "gmesave.dat"
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		if node.is_in_group("Cube"):
			pass

func write_save():
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_line("current_map")
	file.store_line(Global.current_map_name)
	file.store_line("`")
	file.store_line("player_position")
	file.store_float(Global.player.global_position.x)
	file.store_float(Global.player.global_position.y)
	file.store_float(Global.player.global_position.z)
	file.store_line("player_rotation")
	file.store_float(Global.player.Camera3Dm.global_rotation.x)
	file.store_float(Global.player.global_rotation.y)
	file.store_line("`")
	
	file.close()

func read_save(content):
	var current_map
	var plrlocx
	var plrlocy
	var plrlocz
	var plrloc 
	var plrroty
	var plrrotx
	var file = FileAccess.open(save_location, FileAccess.READ)
	if file.get_line() == "current_map":
		current_map = file.get_line()
	if file.get_line() == "`":
		if file.get_line() == "player_position":
			plrlocx = file.get_float()
			plrlocy = file.get_float()
			plrlocz = file.get_float()
			plrloc = Vector3(plrlocx, plrlocy, plrlocz)
		if file.get_line() == "player_rotation":
			plrrotx = file.get_float()
			plrroty = file.get_float()
	
	file.close()
	
	if content == "current_map": return current_map
	elif content == "plrloc": return plrloc
	elif content == "plrroty": return plrroty
	elif content == "plrrotx": return plrrotx

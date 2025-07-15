extends Node

var save_location = "user://"
var save_nodes
var curspos

signal writeobjects

func ready_save(savenum):
	save_location = "user://" + str(savenum) + "gmesave.dat"
	save_nodes = get_tree().get_nodes_in_group("Persist")

func write_save():
	#Open file
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	#Save player and map
	file.store_line("current_map")
	file.store_line(Global.current_map_name)
	file.store_var(Global.skyrotation)
	file.store_var(Global.orbitangle)
	file.store_line("`")
	file.store_line("player_position")
	file.store_float(Global.player.global_position.x)
	file.store_float(Global.player.global_position.y)
	file.store_float(Global.player.global_position.z)
	file.store_line("player_rotation")
	file.store_float(Global.player.Camera3Dm.global_rotation.x)
	file.store_float(Global.player.global_rotation.y)
	file.store_line("player velocity")
	file.store_var(Global.player.velocity)
	file.store_line("`")
	#Save the objects
	file.store_line("objects")
	file.store_64(save_nodes.size())
	for node in save_nodes:
		if node.is_in_group("Cube"):
			for i : RigidBody3D in save_nodes:
				file.store_line(i.name)
				file.store_var(i.global_position)
				file.store_var(i.global_rotation)
				file.store_var(i.linear_velocity)
				file.store_var(i.angular_velocity)
	
	file.close()

func read_save(content):
	var current_map
	var skyrot
	var orbitang
	var plrlocx
	var plrlocy
	var plrlocz
	var plrloc 
	var plrroty
	var plrrotx
	var plrvel
	var file = FileAccess.open(save_location, FileAccess.READ)
	if file.get_line() == "current_map":
		current_map = file.get_line()
		skyrot = file.get_var()
		orbitang = file.get_var()
	if file.get_line() == "`":
		if file.get_line() == "player_position":
			plrlocx = file.get_float()
			plrlocy = file.get_float()
			plrlocz = file.get_float()
			plrloc = Vector3(plrlocx, plrlocy, plrlocz)
		if file.get_line() == "player_rotation":
			plrrotx = file.get_float()
			plrroty = file.get_float()
		if file.get_line() == "player velocity":
			plrvel = file.get_var()
	
	if file.get_line() == "`" and file.get_line() == "objects":
		var objectsamt = file.get_64()
		print("Amount of saved objects" + str(objectsamt))
		for obj in objectsamt:
			pass
	
	file.close()
	
	if content == "current_map": return current_map
	elif content == "skyrot": return skyrot
	elif content == "orbitang": return orbitang
	elif content == "plrloc": return plrloc
	elif content == "plrroty": return plrroty
	elif content == "plrrotx": return plrrotx
	elif content == "plrvel": return plrvel

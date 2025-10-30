extends Node

var save_location = "user://saves"
var save_nodes
var savecount
var savenum
var missingsaves = 0

var container

func _ready() -> void:
	if !DirAccess.open("user://saves"):
		DirAccess.open("user://").make_dir("user://saves")
	
	get_files()

func get_files():
	await get_tree().process_frame
	savecount = DirAccess.open("user://saves").get_files().size()
	#print(DirAccess.open("user://saves").get_files())
	var i = 0
	while i < savecount:
		i += 1
		if ready_save(i):
			var savefile = load("res://Scenes/SaveFile.tscn")
			var instance = savefile.instantiate()
			container.add_child.call_deferred(instance)
			instance.file = read_save("id")
			instance.map = read_save("current_map")
			instance.date = read_save("date")
			instance.update()
		else:
			missingsaves += 1
			savecount += 1

func ready_save(savenumber):
	savecount = DirAccess.open("user://saves").get_files().size() + missingsaves
	savenum = savenumber
	save_location = "user://saves/" + str(savenum) + "gmesave.dat"
	save_nodes = get_tree().get_nodes_in_group("Persist")
	if !FileAccess.file_exists(save_location):
		return false
	else:
		return true
	

func write_save():
	#Open file
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	#Save player and map
	file.store_line("id")
	file.store_32(savenum)
	file.store_line("date")
	file.store_line(Time.get_date_string_from_system())
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
	store_objects(file.get_position())
	
	file.close()
	savecount = DirAccess.open("user://saves").get_files().size()
	await RenderingServer.frame_post_draw
	

func read_save(content):
	var saveid
	var date
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
	if file.get_line() == "id":
		saveid = file.get_32()
	if file.get_line() == "date":
		date = file.get_line()
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
	
	if content == "id": return saveid
	elif content == "date": return date
	elif content == "current_map": return current_map
	elif content == "skyrot": return skyrot
	elif content == "orbitang": return orbitang
	elif content == "plrloc": return plrloc
	elif content == "plrroty": return plrroty
	elif content == "plrrotx": return plrrotx
	elif content == "plrvel": return plrvel
	
	if file.get_line() == "`" and file.get_line() == "objects" and content == "objects":
		get_objects(file.get_position())
	
	file.close()

func store_objects(pos):
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.seek(pos)
	file.store_line("objects")
	file.store_64(save_nodes.size())
	for node in save_nodes:
		if node.is_in_group("Cube"):
			for i : RigidBody3D in save_nodes:
				file.store_line("GCube")
				file.store_line(i.name)
				file.store_var(i.global_position)
				file.store_var(i.global_rotation)
				file.store_var(i.linear_velocity)
				file.store_var(i.angular_velocity)

func get_objects(pos):
	var file = FileAccess.open(save_location, FileAccess.READ)
	file.seek(pos)
	Global.load_objects.emit()
	var objectsamt = file.get_64()
	print("Amount of saved objects" + str(objectsamt))
	for obj in objectsamt:
		var group = file.get_line()
		if group == "GCube":
			var cube = load("res://Scenes/PuzzleElements/Cube.tscn")
			var instance : RigidBody3D = cube.instantiate()
			Global.current_map.add_child.call_deferred(instance)
			await get_tree().process_frame
			instance.name = file.get_line()
			instance.global_position = file.get_var()
			instance.global_rotation = file.get_var()
			instance.linear_velocity = file.get_var()
			instance.angular_velocity = file.get_var()

func delete_save():
	DirAccess.remove_absolute(save_location)

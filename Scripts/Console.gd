extends Node

func cmd(input : String):
	if input.contains("map"):
		if input.contains("devtest"):
			Global.change_map("dev_test")
			await get_tree().process_frame
			Global.spawnplayer(Global.current_map.get_node("SpawnPoint").global_transform)
		elif input.contains("mp_01"):
			Global.change_map("mp_01")
			await get_tree().process_frame
			Global.spawnplayer(Global.current_map.get_node("SpawnPoint").global_transform)
		elif input.contains("mp_02"):
			Global.change_map("mp_02")
			await get_tree().process_frame
			Global.spawnplayer(Global.current_map.get_node("SpawnPoint").global_transform)
		elif input.contains("mp_03"):
			Global.change_map("mp_03")
			await get_tree().process_frame
			Global.spawnplayer(Global.current_map.get_node("SpawnPoint").global_transform)
		elif input.contains("mp_04"):
			Global.change_map("mp_04")
			await get_tree().process_frame
			Global.spawnplayer(Global.current_map.get_node("SpawnPoint").global_transform)
		elif input.contains("mp_05"):
			Global.change_map("mp_05")
			await get_tree().process_frame
			Global.spawnplayer(Global.current_map.get_node("SpawnPoint").global_transform)
		elif input.contains("full_station"):
			Global.change_map("full_station")
			await get_tree().process_frame
			Global.spawnplayer(Global.current_map.get_node("SpawnPoint").global_transform)
		elif input.contains("secret"):
			Global.change_map("secret")
			await get_tree().process_frame
			Global.spawnplayer(Global.current_map.get_node("SpawnPoint").global_transform)
		elif input.contains("surf_puzzle"):
			Global.change_map("surf_puzzle")
			await get_tree().process_frame
			Global.root.usemapenv(true, load("res://Assets/Materials/SurfaceSky.tres"))
			Global.spawnplayer(Global.current_map.get_node("SpawnPoint").global_transform)
		elif input.contains("void_puzzle"):
			Global.change_map("void_puzzle")
			await get_tree().process_frame
			Global.root.usemapenv(true, load("res://Assets/Materials/VoidSky.tres"))
			Global.spawnplayer(Global.current_map.get_node("SpawnPoint").global_transform)
		
		
		else:
			print("Not a valid map name")
	else:
		print("Not a valid command")

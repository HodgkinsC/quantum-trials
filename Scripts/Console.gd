extends Node

func cmd(input : String):
	if input.contains("map"):
		if input.contains("dev_test"):
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
		
		
		else:
			print("Not a valid map name")
	else:
		print("Not a valid command")

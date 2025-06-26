extends Node

func cmd(input : String):
	if input.contains("load_level"):
		if input.contains("dev_test"):
			Global.change_map("dev_test")
		elif input.contains("mp_01"):
			Global.change_map("mp_01")
		elif input.contains("mp_02"):
			Global.change_map("mp_02")
			await get_tree().process_frame
			Global.spawnplayer(Vector3(-28.0, 1.0, -14.0))
		
		
		
		else:
			print("Not a valid map name")
	else:
		print("Not a valid command")

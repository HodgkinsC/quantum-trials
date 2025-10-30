extends Node

func cmd(input : String):
	var words : Array = input.split(" ", false)
	if words.has("quit"):
		get_tree().quit()
	
	elif words.has("map"):
		if ResourceLoader.exists("res://Scenes/Maps/" + words.get(words.find("map") + 1) + ".tscn"):
			Global.change_map(words.get(words.find("map") + 1))
			await get_tree().process_frame
			Global.root.usemapenv(true)
			Global.spawnplayer(Global.current_map.get_node("SpawnPoint").global_transform)
		else:
			print("Not a valid map id")
	
	elif words.has("retry"):
		Console.cmd("map " + Global.current_map_name)
	
	elif words.has("env"):
		if ResourceLoader.exists("res://Assets/Environments/" + words.get(words.find("env") + 1) + ".tres"):
			Global.root.usemapenv(true, load("res://Assets/Environments/" + words.get(words.find("env") + 1) + ".tres"))
		else:
			print("Not a valid environment id")
	
	elif words.has("sv_cheats"):
		if words.get(words.find("sv_cheats") + 1) == "1":
			Global.player.debug_mode = true
		elif words.get(words.find("sv_cheats") + 1) == "0":
			Global.player.debug_mode = false
	
	elif words.has("silly_mode"):
		if words.get(words.find("silly_mode") + 1) == "1":
			Global.root.usemapenv(true,load("res://Assets/Environments/Silly.tres"))
		elif words.get(words.find("silly_mode") + 1) == "0":
			Global.root.usemapenv(true)
	
	elif words.has("andrew"):
		print("andrew")
		Global.root.queue_free()
		print("hee hee")
		await get_tree().create_timer(5).timeout
		get_tree().change_scene_to_file("res://Scenes/Maps/nfhuailejkkwhjkadhnkdal.tscn")
	
	else:
		print("Not a valid command")

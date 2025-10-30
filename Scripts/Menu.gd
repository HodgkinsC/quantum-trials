extends Control

@export var in_game: bool

@onready var PlayerPos = $Debug/PlayerPos
@onready var PlayerVel = $Debug/PlayerVel
@onready var CurrentMap = $Debug/CurrentMap

var disabled = false

func _ready() -> void:
	SaveSystem.container = $SaveMenu/ScrollContainer/VBoxContainer
	Global.menu = self
	if Global.current_map_name == "menu":
		await get_tree().process_frame
		changemenu(0)
	for button in get_children():
		if button is Button:
			button.connect("mouse_entered", mousehover)
			button.connect("pressed", mouseup)
	Global.ChangeMap.connect(changemap)

func mouseup():
	$MenuButtonClick.play()

func mousehover():
	$MenuButtonHover.play()

func changemenu(which : int):
	if which == 0:
		in_game = false
		visible = true
		Global.player.disabled = true
		Global.paused = false
		Global.mouse_free = true
		$Title.visible = true
		$"New Game".visible = true
		$Resume.visible = false
		get_tree().root.get_node("/root/SceneManager/Skybox/StationCam").current = true
		get_tree().root.get_node("/root/SceneManager/Skybox/StationCam").visible = true
		get_tree().root.get_node("/root/SceneManager/SkyboxStation").visible = true
	else:
		in_game = true
		Global.player.disabled = false
		Global.mouse_free = false
		$Title.visible = false
		$"New Game".visible = false
		$Resume.visible = true
		get_tree().root.get_node("/root/SceneManager/Skybox/StationCam").current = false
		get_tree().root.get_node("/root/SceneManager/Skybox/StationCam").visible = false
		get_tree().root.get_node("/root/SceneManager/SkyboxStation").visible = false

func _process(_delta: float) -> void:
	process_debug()

func process_debug():
	PlayerPos.text = "Player Position: " + str(Global.player.global_position)
	PlayerVel.text = "Player Velocity: " + str(Global.player.velocity)
	CurrentMap.text = "Current Map: " + str(Global.current_map)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc") and !Global.usingcomputer:
		if Global.current_map and !Global.current_map.is_in_group("Menu"):
			Global.paused = !Global.paused
			self.visible = !self.visible
		elif !Global.current_map:
			Global.paused = !Global.paused
			self.visible = !self.visible
	
	get_tree().paused = Global.paused

func _on_new_game_pressed():
	Global.paused = false
	changemenu(1)
	visible = false
	Global.change_map("mp_01")
	Global.root.usemapenv(false, null)
	await get_tree().process_frame
	Global.spawnplayer(Global.current_map.get_node("SpawnPoint").global_transform)

func _on_settings_pressed():
	$SettingsMenu.visible = !$SettingsMenu.visible

func _on_resume_pressed() -> void:
	Global.paused = !Global.paused
	visible = !visible

func _on_quit_pressed() -> void:
	if in_game:
		Console.cmd("map menu")
	else:
		get_tree().quit()

func _on_sens_slider_value_changed(value: float) -> void:
	Global.player.look_sensitivity = value / 1000

func _on_check_button_toggled(toggled_on: bool) -> void:
	Global.player.debug_mode = toggled_on
	$Console.visible = toggled_on
	$Debug.visible = toggled_on
	$DebugBG.visible = toggled_on

func _on_save_load_pressed() -> void:
	$SaveMenu.visible = !$SaveMenu.visible

func _on_save_pressed() -> void:
	var savenum = SaveSystem.savecount + 1
	SaveSystem.ready_save(savenum)
	SaveSystem.write_save()
	
	var dir = DirAccess.open("user://")
	dir.make_dir("savethumbnails")
	var img = get_viewport().get_texture().get_image()
	img.save_jpg("user://savethumbnails/img" + str(savenum) +".jpg")
	
	var savefile = load("res://Scenes/SaveFile.tscn")
	var instance = savefile.instantiate()
	$SaveMenu/ScrollContainer/VBoxContainer.add_child.call_deferred(instance)
	instance.file = savenum
	instance.map = SaveSystem.read_save("current_map")
	instance.date = SaveSystem.read_save("date")
	instance.update()

func _on_load_pressed() -> void:
	Global.load_objects.emit()
	Global.change_map(SaveSystem.read_save("current_map"))
	await get_tree().process_frame
	Global.player.global_position = SaveSystem.read_save("plrloc")
	Global.player.global_rotation.y = SaveSystem.read_save("plrroty")
	Global.player.Camera3Dm.global_rotation.x = SaveSystem.read_save("plrrotx")
	Global.player.velocity = SaveSystem.read_save("plrvel")
	SaveSystem.read_save("objects")
	Global.paused = false
	visible = false
	changemenu(1)

func _on_delete_save_pressed() -> void:
	$SaveMenu/AreYouSure.visible = true

func _on_yes_pressed() -> void:
	if $SaveMenu/AreYouSure.visible:
		SaveSystem.delete_save()
		$SaveMenu/AreYouSure.visible = false
		for file in $SaveMenu/ScrollContainer/VBoxContainer.get_children():
			if file.file == SaveSystem.savenum:
				file.queue_free()

func _on_no_pressed() -> void:
	if $SaveMenu/AreYouSure.visible:
		$SaveMenu/AreYouSure.visible = false

#//-- Audio --\\#

func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_game_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Game"), linear_to_db(value))

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))

func _on_ui_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UI"), linear_to_db(value))

func _on_fullscreencheck_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func changemap():
	Global.paused = false
	changemenu(1)
	visible = false

#func _on_resdropdown_item_selected(index: int) -> void:
	#if index == 0:
		#get_window().set_size(Vector2i(1280,720))
	#elif index == 1:
		#get_window().set_size(Vector2i(1920,1080))
	#elif index == 2:
		#get_window().set_size(Vector2i(4096,2160))
	#elif index == 3:
		#get_window().set_size(Vector2i(1366,768))

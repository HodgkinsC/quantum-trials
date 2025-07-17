extends Control

@export var in_game: bool

@onready var PlayerPos = $Debug/PlayerPos
@onready var PlayerVel = $Debug/PlayerVel
@onready var CurrentMap = $Debug/CurrentMap

var disabled = false

func _ready() -> void:
	SaveSystem.container = $SaveMenu/ScrollContainer/VBoxContainer
	if Global.current_map_name == "menu":
		await get_tree().process_frame
		changemenu(0)
	

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
	else:
		in_game = true
		Global.player.disabled = false
		Global.mouse_free = false
		$Title.visible = false
		$"New Game".visible = false
		$Resume.visible = true

func _process(_delta: float) -> void:
	process_debug()

func process_debug():
	PlayerPos.text = "Player Position: " + str(Global.player.global_position)
	PlayerVel.text = "Player Velocity: " + str(Global.player.velocity)
	CurrentMap.text = "Current Map: " + str(Global.current_map)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc") and !Global.usingcomputer and !Global.current_map.is_in_group("Menu"):
		Global.paused = !Global.paused
		self.visible = !self.visible
	
	get_tree().paused = Global.paused

func _on_new_game_pressed():
	Global.paused = false
	changemenu(1)
	visible = false
	Global.change_map("mp_01")
	Global.root.usemapenv(false)
	await get_tree().process_frame
	Global.spawnplayer(Global.current_map.get_node("SpawnPoint").global_transform)

func _on_settings_pressed():
	$SettingsMenu.visible = !$SettingsMenu.visible

func _on_resume_pressed() -> void:
	Global.paused = !Global.paused
	visible = !visible

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_sens_slider_value_changed(value: float) -> void:
	Global.player.look_sensitivity = value / 1000

func _on_check_button_toggled(toggled_on: bool) -> void:
	Global.player.debug_mode = toggled_on

func _on_save_load_pressed() -> void:
	$SaveMenu.visible = !$SaveMenu.visible

func _on_save_pressed() -> void:
	SaveSystem.ready_save(SaveSystem.savecount + 1)
	SaveSystem.write_save()
	var savefile = load("res://Scenes/SaveFile.tscn")
	var instance = savefile.instantiate()
	$SaveMenu/ScrollContainer/VBoxContainer.add_child.call_deferred(instance)
	instance.file = SaveSystem.savecount
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


func _on_override_save_pressed() -> void:
	SaveSystem.write_save()

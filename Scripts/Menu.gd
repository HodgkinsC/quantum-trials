extends Control

@export var in_game: bool

@onready var PlayerPos = $Debug/PlayerPos
@onready var PlayerVel = $Debug/PlayerVel
@onready var CurrentMap = $Debug/CurrentMap

func _ready() -> void:
	if in_game:
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
	if Input.is_action_just_pressed("esc") and !Global.usingcomputer:
		Global.paused = !Global.paused
		self.visible = !self.visible
	
	get_tree().paused = Global.paused

func _on_new_game_pressed():
	Global.change_map("mp_01")

func _on_settings_pressed():
	$SettingsMenu.visible = !$SettingsMenu.visible

func _on_resume_pressed() -> void:
	Global.paused = !Global.paused
	visible = !visible

func _on_quit_pressed() -> void:
	get_tree().quit()

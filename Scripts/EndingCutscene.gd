extends Node

signal startcutscene

func _ready() -> void:
	startcutscene.connect(cutscene)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debugbutton"):
		startcutscene.emit()

func cutscene():
	$Camera3D.current = true
	$AnimationPlayer.play("Cutscene")
	var pos = $"../Environment/Core/TheDarkCrystal(TM)/Audio".get_playback_position()
	$Audio.play(pos)
	$"../Environment/Core/TheDarkCrystal(TM)/Audio".stop()
	await get_tree().create_timer(70).timeout
	$Camera3D.current = false
	pos = $Audio.get_playback_position()
	$"../Environment/Core/TheDarkCrystal(TM)/Audio".play(pos)
	$Audio.stop()
	Global.root.get_node("Skybox/Orbit/PlanetDestination").visible = true
	Global.root.get_node("Skybox/Orbit/Planet").visible = false

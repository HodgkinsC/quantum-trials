extends Node

@export var trigger : Node3D

func _ready() -> void:
	Global.startcutscene.connect(cutscene)

func cutscene():
	if trigger.working == 2:
		Global.player.disabled = true
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
		Global.root.get_node("Skybox/Orbit/PlanetDestination").scale = Vector3(1, 1, 1)
		Global.root.get_node("Skybox/Orbit/Planet").visible = false
		Global.player.disabled = false
		Global.root.skyboxrotate = false
		Global.root.sun.visible = false

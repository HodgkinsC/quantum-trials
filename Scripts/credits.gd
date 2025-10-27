extends Node3D

func _ready() -> void:
	Global.root.skyboxrotate = false
	Global.root.sun.visible = false
	await get_tree().create_timer(1).timeout
	$CreditsAnim.play("credits")
	await get_tree().create_timer(70).timeout
	Global.root.skyboxrotate = true
	Global.root.sun.visible = true
	Console.cmd("map menu")

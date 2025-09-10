extends StaticBody3D

signal use

var done = false
var blasting = false

var corepos = Vector3(14.875, 3.625, 0.0)
@onready var core = $"../../Core"
@onready var beam : Path3D = $Teleportbeam
@onready var audio = $Audio
@onready var level = preload("res://Scenes/Maps/void_puzzle.tscn")

func _ready() -> void:
	use.connect(activate)
	beam.visible = false

func activate():
	if !done:
		done = true
		var instance = level.instantiate()
		blasting = true
		await get_tree().create_timer(1).timeout
		beamlock()
		audio.play()
		await get_tree().create_timer(0.5).timeout
		Global.root.add_child(instance)
		instance.global_position = Vector3(100, 0, 0)
		Global.root.sun.visible = false
		Global.root.env.environment = load("res://Assets/Materials/VoidSky.tres")
		blasting = false
		Global.player.global_position = instance.get_node("SpawnPoint").global_position
		

func beamlock():
	beam.visible = true
	while blasting:
		beam.curve.set_point_position(1, to_local(Global.player.global_position))
		await get_tree().process_frame
	beam.visible = false

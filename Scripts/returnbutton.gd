extends StaticBody3D

signal use

var done = false
var blasting = false

@export var location = Vector3()
@export var parent : Node3D

@onready var beam : Path3D = $Teleportbeam
@onready var audio = $Audio

func _ready() -> void:
	use.connect(activate)
	beam.visible = false

func activate():
	if !done:
		done = true
		blasting = true
		await get_tree().create_timer(1).timeout
		beamlock()
		audio.play()
		await get_tree().create_timer(0.5).timeout
		Global.root.sun.visible = true
		Global.root.env.environment = load("res://Assets/Environments/Skybox.tres")
		blasting = false
		Global.player.global_position = location
		Global.current_map.visible = true
		parent.queue_free()

func beamlock():
	beam.visible = true
	while blasting:
		beam.curve.set_point_position(1, to_local(Global.player.global_position))
		await get_tree().process_frame
	beam.visible = false

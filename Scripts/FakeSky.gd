extends Node3D

@onready var camera = $Camera3D
@onready var sky = $MeshInstance3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sky.rotation = Global.skyrotation
	camera.rotation = Global.player.Camera3Dm.global_rotation

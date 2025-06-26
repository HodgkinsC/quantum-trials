extends RigidBody3D

@onready var mesh = $Mesh

var on = preload("res://Assets/Materials/CubeOn.tres")
var off = preload("res://Assets/Materials/CubeOff.tres")

func activate():
	mesh.set_surface_override_material(0, on)

func deactivate():
	mesh.set_surface_override_material(0, off)

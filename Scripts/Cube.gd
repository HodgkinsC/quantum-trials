extends RigidBody3D

@onready var mesh = $Mesh
@export var locked : bool

var on = preload("res://Assets/Materials/CubeOn.tres")
var off = preload("res://Assets/Materials/CubeOff.tres")

func _ready() -> void:
	if locked:
		remove_from_group("Grabbable")

func activate():
	mesh.set_surface_override_material(0, on)

func deactivate():
	mesh.set_surface_override_material(0, off)

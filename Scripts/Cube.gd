extends Node3D

@onready var mesh = $Mesh
@export var locked : bool

var on = preload("res://Assets/Materials/CubeOn.tres")
var off = preload("res://Assets/Materials/CubeOff.tres")

func _ready() -> void:
	if locked:
		remove_from_group("Grabbable")
	Global.load_objects.connect(delete)

func delete():
	self.queue_free()

func activate():
	mesh.set_surface_override_material(0, on)

func deactivate():
	mesh.set_surface_override_material(0, off)

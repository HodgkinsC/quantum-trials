extends StaticBody3D

@export var state : bool
@onready var mesh = $Mesh
@onready var visi = $VisibleOnScreenNotifier3D

var on = preload("res://Assets/Materials/CubeOn.tres")
var off = preload("res://Assets/Materials/CubeOff.tres")

func _ready() -> void:
	if state:
		mesh.set_surface_override_material(0, on)
	else:
		mesh.set_surface_override_material(0, off)
	visi.connect("screen_exited", change)

func change():
	var rand = randi_range(0, 1)
	if rand == 1:
		state = true
	else:
		state = false
	
	if state:
		mesh.set_surface_override_material(0, on)
	else:
		mesh.set_surface_override_material(0, off)

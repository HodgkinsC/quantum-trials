extends StaticBody3D

signal use

var done = false

@onready var corepos = Vector3(14.875, 3.625, 0.0)

func _ready() -> void:
	connect("use", activate)

func activate():
	if !done:
		done = true
		
		

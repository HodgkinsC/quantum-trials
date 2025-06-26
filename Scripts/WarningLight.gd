extends Node3D

@onready var SpinningPart = $SpinningPart

func _process(_delta: float) -> void:
	SpinningPart.rotation.y += deg_to_rad(10)

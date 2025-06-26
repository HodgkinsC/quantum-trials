extends Node3D

@onready var notif = $VisibleOnScreenNotifier3D

@export var speed = Vector3(0.03, 0.03, 0.03)

func _ready() -> void:
	notif.connect("screen_exited", change)

func _process(_delta: float) -> void:
	rotation_degrees += speed

func change():
	rotation_degrees = Vector3(randf_range(0, 360), randf_range(0, 360), randf_range(0, 360))

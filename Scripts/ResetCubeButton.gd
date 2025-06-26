extends StaticBody3D

signal use

@export var cube : RigidBody3D
var spawnpos

func _ready() -> void:
	use.connect(activate)
	spawnpos = cube.global_transform

func activate():
	print("activated")
	cube.global_transform = spawnpos
	cube.linear_velocity = Vector3.ZERO
	cube.angular_velocity = Vector3.ZERO

extends MeshInstance3D

func _process(_delta: float) -> void:
	rotation_degrees += Vector3(0.1, 0, 0)

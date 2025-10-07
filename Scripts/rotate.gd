extends MeshInstance3D

func _process(delta: float) -> void:
	rotation_degrees += Vector3(7, 0, 0) * delta

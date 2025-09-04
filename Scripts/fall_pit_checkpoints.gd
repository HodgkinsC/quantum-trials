extends Area3D

var activecheck : Node3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.global_transform = activecheck.global_transform
		body.velocity = Vector3.ZERO

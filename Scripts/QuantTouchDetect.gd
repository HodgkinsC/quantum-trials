extends Area3D

var canmove = true

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		canmove = false
		print(canmove)

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		canmove = true
		print(canmove)

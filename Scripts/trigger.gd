extends Area3D

func _ready() -> void:
	get_parent().visible = false

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		get_parent().visible = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		get_parent().visible = false

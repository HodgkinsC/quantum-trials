extends Area3D

@export var level : String
@export var door : Node3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if door:
			door.deactivate()
			await get_tree().create_timer(1).timeout
		
		Global.change_map(level)

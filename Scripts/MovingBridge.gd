extends StaticBody3D

func _ready() -> void:
	get_node("AnimationPlayer").play("RESET")

func activate():
	get_node("AnimationPlayer").play("MoveAcross")

func deactivate():
	get_node("AnimationPlayer").play("MoveBack")

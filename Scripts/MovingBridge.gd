extends StaticBody3D

var location = 0
var active = 0

func _ready() -> void:
	get_node("AnimationPlayer").play("RESET")

func activate(action):
	active += 1
	if action == 0 and location != 1:
		get_node("AnimationPlayer").play("MoveAcross")
		location = 1
	elif action == 1 and location != -1:
		get_node("AnimationPlayer").play("Reverse")
		location = -1

func deactivate(_action):
	active -= 1
	if location != 0 and active == 0:
		get_node("AnimationPlayer").play("MoveBack")
		location = 0

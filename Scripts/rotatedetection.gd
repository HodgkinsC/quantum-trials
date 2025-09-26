extends Area3D

@onready var lightswitch = $"../../LightSwitch"

var objects = []
var rotating = false

func _ready() -> void:
	lightswitch.rotate.connect(rotatenow)

func _on_body_entered(body: Node3D) -> void:
	print("detect enter")
	if body.is_in_group("Cube") and !rotating:
		objects.append(body)
		print("body added")

func _on_body_exited(body: Node3D) -> void:
	print("detect exit")
	if body.is_in_group("Cube") and !rotating:
		objects.erase(body)
		print("body removed")

func rotatenow():
	print("rotating")
	rotating = true
	for i : Node3D in objects:
		i.reparent(get_parent())
	await get_tree().create_timer(0.5).timeout
	for i in objects:
		i.reparent(get_parent().get_parent())
	rotating = false

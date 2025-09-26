extends StaticBody3D

@export var target1 : Node3D
@export var target2 : Node3D
@export var action : int

var pressed = false
var current_bodies = 0

func update():
	if current_bodies > 0:
		pressed = true
		if target1: target1.activate(action)
		if target2: target2.activate(action)
	else:
		pressed = false
		if target1: target1.deactivate(action)
		if target2: target2.deactivate(action)

func _on_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group("Element") or body.is_in_group("Player"):
		current_bodies += 1
		if body.is_in_group("Cube"):
			body.activate()
		update()

func _on_detector_body_exited(body: Node3D) -> void:
	if body.is_in_group("Element") or body.is_in_group("Player"):
		current_bodies -= 1
		if body.is_in_group("Cube"):
			body.deactivate()
		update()

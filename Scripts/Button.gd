extends StaticBody3D

@export var target : Node3D

var pressed = false
var current_bodies = 0

func update():
	if current_bodies > 0:
		pressed = true
		if target: target.activate()
	else:
		pressed = false
		if target: target.deactivate()

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

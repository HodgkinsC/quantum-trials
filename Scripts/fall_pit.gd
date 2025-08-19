extends Area3D

var plrmadeacross = false
var cubemadeacross = false

func _on_body_entered(body: Node3D) -> void:
	if !plrmadeacross:
		if body.is_in_group("Player"):
			body.global_position = $PlrCheck.global_position
			body.velocity = Vector3.ZERO
	if !cubemadeacross:
		if body.is_in_group("Cube"):
			body.global_position = $CubeCheck.global_position
			body.linear_velocity = Vector3.ZERO
	if plrmadeacross:
		if body.is_in_group("Player"):
			body.global_position = $PlrCheck2.global_position
			body.velocity = Vector3.ZERO
	if cubemadeacross:
		if body.is_in_group("Cube"):
			body.global_position = $CubeCheck2.global_position
			body.linear_velocity = Vector3.ZERO


func _on_plr_across_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		plrmadeacross = true

func _on_plr_across_cube_body_entered(body: Node3D) -> void:
	if body.is_in_group("Cube"):
		cubemadeacross = true
		if plrmadeacross:
			plrmadeacross = false

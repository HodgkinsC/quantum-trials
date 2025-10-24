extends Node3D

@onready var worldenv : WorldEnvironment = $".."

func _on_env_change_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		worldenv.environment.background_energy_multiplier -= 0.5
		$EnvChange.queue_free()

func _on_env_change_2_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		worldenv.environment.background_energy_multiplier -= 0.25
		$EnvChange2.queue_free()

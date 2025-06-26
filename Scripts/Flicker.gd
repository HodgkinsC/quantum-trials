extends SpotLight3D

func _ready() -> void:
	while true:
		visible = true
		await get_tree().create_timer(randf_range(0.01, 0.5)).timeout
		visible = false
		await get_tree().create_timer(randf_range(1, 5)).timeout

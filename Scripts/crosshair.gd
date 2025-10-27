extends Control

func _process(delta: float) -> void:
	if Global.current_map_name == "menu" or Global.paused or Global.player.disabled:
		visible = false
	else:
		visible = true

extends Control

func _process(delta: float) -> void:
	if Global.current_map_name != "menu":
		visible = !Global.paused
	else:
		visible = false

extends Control

var current
var mouse_pos = Vector2()


func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text == "31589":
		Global.thatonedoor.activate()

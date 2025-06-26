extends LineEdit

func _on_text_submitted(new_text: String) -> void:
	Console.cmd(new_text)

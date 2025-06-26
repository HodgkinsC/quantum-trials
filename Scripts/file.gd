extends Button

@onready var screen = self.get_parent().get_parent()

func _pressed() -> void:
	if get_child(0):
		if screen.current:
			screen.current.visible = false
		screen.current = get_child(0)
		get_child(0).visible = true

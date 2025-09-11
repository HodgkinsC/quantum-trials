extends StaticBody3D

signal use
signal rotate

func _ready() -> void:
	use.connect(activate)

func activate():
	$Lights.visible = false
	rotate.emit()
	await get_tree().create_timer(1).timeout
	$Lights.visible = true

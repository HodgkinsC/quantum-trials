extends StaticBody3D

signal use
signal rotate

@onready var platforms : Node3D = get_parent().get_node("Platforms")
@onready var lights = $Lights

func _ready() -> void:
	use.connect(activate)

func activate():
	$Lights.visible = false
	rotate.emit()
	platforms.visible = false
	platforms.rotation_degrees.y += 90
	await get_tree().create_timer(1).timeout
	platforms.visible = true
	$Lights.visible = true

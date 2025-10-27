extends StaticBody3D

signal use

@onready var loading = $Loading
@export var map : String

func _ready() -> void:
	use.connect(activate)

func activate():
	loading.visible = true
	await get_tree().create_timer(1).timeout
	Global.change_map(map)

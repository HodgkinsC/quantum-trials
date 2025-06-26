extends Node3D

@onready var env = $WorldEnvironment
@onready var sun = $DirectionalLight3D

func _ready() -> void:
	Global.root = self
	env.environment.sky_rotation.y += deg_to_rad(-45)
	sun.rotation.y += deg_to_rad(-45)

func usemapenv(use : bool):
	await Global.current_map.ready
	if use:
		env.environment = null
		sun.visible = false
	else:
		if Global.current_map:
			if Global.current_map.has_node("WorldEnvironment"): Global.current_map.get_node("WorldEnvironment").queue_free()
			if Global.current_map.has_node("DirectionalLight3D"): Global.current_map.get_node("DirectionalLight3D").queue_free()

func _process(_delta: float) -> void:
	env.environment.sky_rotation.y += 0.0002
	env.environment.sky_rotation.x += 0.0001
	sun.rotation.y += 0.0002
	sun.rotation.x += 0.0001
	if env.environment.sky_rotation.y >= 360:
		env.environment.sky_rotation.y = 0

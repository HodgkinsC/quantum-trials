extends Node3D

@onready var env : WorldEnvironment = $WorldEnvironment
@onready var sun : Node3D = $Skybox
@onready var planet = $Skybox/Orbit/Planet
@onready var orbit = $Skybox/Orbit

var mainskybox = preload("res://Assets/Environments/Skybox.tres")

func _ready() -> void:
	Global.root = self
	#env.environment.sky_rotation.y += deg_to_rad(-45)
	#sun.rotation.y += deg_to_rad(-45)
	Global.load_objects.connect(load_save)
	Global.startwarp.connect(startwarp)

func startwarp():
	orbit.get_node("AnimationPlayer").play("Warp")

func usemapenv(use : bool, environment : Environment = preload("res://Assets/Environments/Skybox.tres")):
	await get_tree().process_frame
	if use == true:
		if Global.current_map.has_node("DirectionalLight3D"):
			sun.visible = false
		else:
			sun.visible = true
		if Global.current_map.has_node("WorldEnvironment"):
			env.environment = Global.current_map.get_node("WorldEnvironment").environment
		else:
			env.environment = environment
	elif use == false:
		env.environment = mainskybox
		sun.visible = true
		if Global.current_map:
			if Global.current_map.has_node("WorldEnvironment"): Global.current_map.get_node("WorldEnvironment").queue_free()
			if Global.current_map.has_node("DirectionalLight3D"): Global.current_map.get_node("DirectionalLight3D").queue_free()

func _process(_delta: float) -> void:
	if env.environment == mainskybox:
		env.environment.sky_rotation.y += 0.0005
		env.environment.sky_rotation.x += 0.0003
		sun.rotation.y += 0.0005
		sun.rotation.x += 0.0003
		planet.rotation_degrees.y += 0.005
		orbit.rotation_degrees.y -= 0.005
		Global.skyrotation = env.environment.sky_rotation
		Global.orbitangle = orbit.rotation_degrees

func load_save():
	env.environment.sky_rotation = await SaveSystem.read_save("skyrot")
	orbit.rotation_degrees = await SaveSystem.read_save("orbitang")

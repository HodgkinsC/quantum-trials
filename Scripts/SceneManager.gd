extends Node3D

@onready var env = $WorldEnvironment
@onready var sun = $Skybox
@onready var planet = $Skybox/Orbit/Planet
@onready var orbit = $Skybox/Orbit

func _ready() -> void:
	Global.root = self
	env.environment.sky_rotation.y += deg_to_rad(-45)
	sun.rotation.y += deg_to_rad(-45)
	Global.load_objects.connect(load_save)
	Global.startwarp.connect(startwarp)

func startwarp():
	orbit.get_node("AnimationPlayer").play("Warp")

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
	if $Fakesky and !$Fakesky.warping:
		env.environment.sky_rotation.y += 0.0005
		env.environment.sky_rotation.x += 0.0003
		sun.rotation.y += 0.0005
		sun.rotation.x += 0.0003
		planet.rotation_degrees.y += 0.005
		orbit.rotation_degrees.y -= 0.005
		#if env.environment.sky_rotation.y >= 360:
			#while env.environment.sky_rotation.y >= 360:
				#env.environment.sky_rotation.y -= 360
		Global.skyrotation = env.environment.sky_rotation
		Global.orbitangle = orbit.rotation_degrees
	if $Fakesky:
		$Fakesky.global_position = Global.player.Camera3Dm.global_position
	if $Fakesky and !$Fakesky.warping:
		#$Fakesky.sky.global_rotation.y += 0.0005
		#$Fakesky.sky.global_rotation.x += 0.0003
		$Fakesky.sky.global_rotation = env.environment.sky_rotation
		$Fakesky.sky.global_rotation.y  += deg_to_rad(180)
		#$Fakesky.sky.global_rotation.y += 180
	elif $Fakesky and $Fakesky.warping:
		env.environment.sky_rotation = $Fakesky.sky.global_rotation
		sun.rotation = $Fakesky.sky.global_rotation
		env.environment.sky_rotation.y += deg_to_rad(180)
		#env.environment.sky_rotation.x += 180
		#env.environment.sky_rotation.z += 180

func load_save():
	env.environment.sky_rotation = await SaveSystem.read_save("skyrot")
	orbit.rotation_degrees = await SaveSystem.read_save("orbitang")

extends Node3D

@onready var env : WorldEnvironment = $WorldEnvironment
@onready var sun : Node3D = $Skybox
@onready var planet = $Skybox/Orbit/Planet
@onready var orbit = $Skybox/Orbit

func _ready() -> void:
	Global.root = self
	env.environment.sky_rotation.y += deg_to_rad(-45)
	sun.rotation.y += deg_to_rad(-45)
	Global.load_objects.connect(load_save)
	Global.startwarp.connect(startwarp)
	$Fakesky.global_rotation.y += deg_to_rad(180)

func startwarp():
	orbit.get_node("AnimationPlayer").play("Warp")

func usemapenv(use : bool, environment : Environment):
	print('USE ENVIRONMENREMNT!!!!!!!!!!!!!')
	await get_tree().process_frame
	print("DONE WAITING!!!!!!!!!!!!")
	if use == true:
		print("ITs USING ItuwtW!!!!!!!!!")
		env.environment = environment
		sun.visible = false
	elif use == false:
		print("it's really not...")
		env.environment = load("res://Assets/Materials/Skybox.tres")
		sun.visible = true
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
		$Fakesky.global_rotation.y += 0.0005
		$Fakesky.global_rotation.x -= 0.0003
		#$Fakesky.global_rotation = env.environment.sky_rotation
	elif $Fakesky and $Fakesky.warping:
		env.environment.sky_rotation = $Fakesky.sky.global_rotation
		sun.rotation = $Fakesky.sky.global_rotation
		env.environment.sky_rotation.y += deg_to_rad(180)
		$Fakesky.global_rotation_degrees = Vector3(0,0,0)
		#env.environment.sky_rotation.x += 180
		#env.environment.sky_rotation.z += 180

func load_save():
	env.environment.sky_rotation = await SaveSystem.read_save("skyrot")
	orbit.rotation_degrees = await SaveSystem.read_save("orbitang")

extends Node3D

@onready var camera = $Camera3D
@onready var sky = $MeshInstance3D

var warping = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	await get_tree().process_frame
	while !warping:
		sky.rotation = Global.skyrotation
		if Input.is_action_just_pressed("debugbutton"):
			$AnimationPlayer.play("Warp")
			warping = true
			await $AnimationPlayer.animation_finished
			warping = false
		await get_tree().process_frame

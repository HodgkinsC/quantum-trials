extends Node3D

@onready var sky = $MeshInstance3D

var warping = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	visible = false
	await get_tree().process_frame
	while !warping:
		if Input.is_action_just_pressed("debugbutton"):
			Global.startwarp.emit()
			$AnimationPlayer.play("Warp")
			visible = true
			warping = true
			await $AnimationPlayer.animation_finished
			warping = false
			visible = false
		await get_tree().process_frame

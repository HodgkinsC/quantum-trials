extends Node3D

signal use
signal exit

@onready var subview = $Monitor/Screen/SubViewport
@onready var screen = $Monitor/Screen/SubViewport/ComputerScreen
@onready var camera = $Camera3D
var using
var mouse_pos := Vector2()

func _ready() -> void:
	use.connect(open)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc"):
		exit.emit()
	
	#if event is InputEventMouseMotion:
		#mouse_pos =  subview.canvas_transform.affine_inverse() * event.position
		#screen.mouse_pos = mouse_pos
	
	if using:
		subview.push_input(event)

func open():
	Global.player.process_mode = Node.PROCESS_MODE_DISABLED
	Global.usingcomputer = true
	using = true
	var count = 0
	while count < 10:
			Global.player.camera.global_position = camera.global_position
			Global.player.camera.global_rotation = camera.global_rotation
			count += 10
	await exit
	await get_tree().process_frame
	using = false
	Global.usingcomputer = false
	Global.player.process_mode = Node.PROCESS_MODE_INHERIT
	Global.player.camera.position = Vector3.ZERO
	Global.player.camera.rotation = Vector3.ZERO

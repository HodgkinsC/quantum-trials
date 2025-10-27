extends StaticBody3D

signal use

var done = false
var blasting = false

var low = preload("res://Assets/Textures/lowlasers.png")
var med = preload("res://Assets/Textures/medlasers.png")
var high = preload("res://Assets/Textures/highlasers.png")

var corepos = Vector3(14.875, 3.625, 0.0)
@onready var core = $"../../Core"
@onready var beam : Path3D = $Teleportbeam
@onready var audio = $Audio
@onready var level = preload("res://Scenes/Maps/void_puzzle.tscn")
@onready var ui = $Decal
@onready var ui2 = $Decal2

@export var door1 : Node3D
@export var door2 : Node3D

signal cutscenestart

var working = 0

func _ready() -> void:
	use.connect(activate)
	beam.visible = false
	ui.texture_albedo = low
	ui2.texture_albedo = low

func activate():
	if !done:
		done = true
		var instance = level.instantiate()
		blasting = true
		await get_tree().create_timer(1).timeout
		beamlock()
		audio.play()
		await get_tree().create_timer(0.5).timeout
		Global.root.add_child(instance)
		instance.global_position = Vector3(100, 0, 0)
		Global.root.sun.visible = false
		Global.root.env.environment = load("res://Assets/Environments/VoidSky.tres")
		blasting = false
		Global.player.global_position = instance.get_node("SpawnPoint").global_position
		get_parent().get_node("Beams").visible = true
		working += 1
		update()
		Global.current_map.visible = false

func update():
	if working == 0:
		ui.texture_albedo = low
		ui2.texture_albedo = low
	elif working == 1:
		ui.texture_albedo = med
		ui2.texture_albedo = med
		door1.activate()
	elif working == 2:
		ui.texture_albedo = high
		ui2.texture_albedo = high
		door2.activate()
		cutscenestart.emit()

func beamlock():
	beam.visible = true
	while blasting:
		beam.curve.set_point_position(1, to_local(Global.player.global_position))
		await get_tree().process_frame
	beam.visible = false

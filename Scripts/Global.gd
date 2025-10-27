extends Node

var paused = false
var usingcomputer = false
var mouse_free

signal load_objects
signal startwarp
signal ChangeMap
signal startcutscene

var player : Player
@onready var root : SceneManager = get_tree().root.get_node("/root/SceneManager")
var current_map : Node3D
var current_map_name : String

var menu

var skyrotation : Vector3
var orbitangle : Vector3

var thatonedoor : Node3D

func _process(_delta: float) -> void:
	await get_tree().process_frame
	if paused or usingcomputer or mouse_free:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _ready() -> void:
	load_objects.connect(shutup)
	startwarp.connect(shutup)
	Console.cmd("map menu")
	paused = true
	await get_tree().create_timer(1).timeout
	#--Launch Options--#
	Console.cmd("map mp_05")

func change_map(mapname : String):
	ChangeMap.emit()
	var map = load("res://Scenes/Maps/" + mapname + ".tscn")
	var instance = map.instantiate()
	root.add_child.call_deferred(instance)
	if current_map: current_map.queue_free()
	current_map = instance
	current_map_name = mapname
	if current_map_name == "menu":
		await get_tree().process_frame
		menu.changemenu(0)

func spawnplayer(pos):
	player.global_transform = pos

func shutup():
	pass

extends Node

var paused = false
var usingcomputer = false
var mouse_free

signal load_objects
signal startwarp
signal ChangeMap

var player : CharacterBody3D
@onready var root = get_tree().root.get_node("/root/SceneManager")
var current_map : Node3D
var current_map_name : String

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
	change_map("menu")
	root.usemapenv(false, null)
	paused = true
	await get_tree().process_frame
	spawnplayer(current_map.get_node("SpawnPoint").global_transform)
	await get_tree().create_timer(1).timeout
	#--Launch Options--#
	Global.change_map("mp_05")
	await get_tree().process_frame
	Global.root.usemapenv(false, load("res://Assets/Materials/VoidSky.tres"))
	Global.spawnplayer(Global.current_map.get_node("SpawnPoint").global_transform)

func change_map(mapname : String):
	ChangeMap.emit()
	var map = load("res://Scenes/Maps/" + mapname + ".tscn")
	var instance = map.instantiate()
	root.add_child.call_deferred(instance)
	if current_map: current_map.queue_free()
	current_map = instance
	current_map_name = mapname

func spawnplayer(pos):
	player.global_transform = pos

func shutup():
	pass

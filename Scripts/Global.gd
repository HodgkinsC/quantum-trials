extends Node

var paused = false
var usingcomputer = false

var player : CharacterBody3D
@onready var root = get_tree().root.get_node("/root/SceneManager")
var current_map

var thatonedoor : Node3D

func _process(_delta: float) -> void:
	await get_tree().process_frame
	if paused or usingcomputer:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _ready() -> void:
	change_map("mp_03")
	root.usemapenv(false)
	await get_tree().process_frame
	spawnplayer(current_map.get_node("SpawnPoint").global_transform)

func change_map(mapname : String):
	if current_map: current_map.queue_free()
	var map = load("res://Scenes/Maps/" + mapname + ".tscn")
	var instance = map.instantiate()
	root.add_child.call_deferred(instance)
	current_map = instance

func spawnplayer(pos):
	player.global_transform = pos

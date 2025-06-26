extends Node3D

#@export var locations : PackedVector3Array
#@export var rotations : PackedVector3Array
@onready var notif = self
@export var object : Node3D

var possiblelocations = []

var rand
var current = rand

signal move

func _ready() -> void:
	move.connect(change)
	change()

func change():
	for i in get_children():
		if !i.viewed and !i.current:
			possiblelocations.append(i)
	
	if !possiblelocations.size() < 1:
		if rand:
			rand.current = false
		possiblelocations.erase(current)
		rand = possiblelocations.pick_random()
		while rand == current:
			rand = possiblelocations.pick_random()
		rand.current = true
		current = rand
		possiblelocations.clear()
		object.global_position = rand.global_position
		object.global_rotation = rand.global_rotation

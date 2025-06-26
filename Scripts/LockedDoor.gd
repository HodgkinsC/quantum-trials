extends Node3D

@onready var anim = $AnimationPlayer
@onready var closedcoll = $ClosedColl

var open = false

func _ready() -> void:
	Global.thatonedoor = self

func activate():
	if !open:
		open = true
		closedcoll.set_collision_mask_value(1, false)
		closedcoll.set_collision_layer_value(1, false)
		anim.play("open")

func deactivate():
	if open:
		open = false
		closedcoll.set_collision_mask_value(1, true)
		closedcoll.set_collision_layer_value(1, true)
		anim.play("close")

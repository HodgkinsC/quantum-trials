extends CSGCombiner3D

@onready var player = $"../CharacterBody3D"

func _process(_delta: float) -> void:
	global_position.z = player.global_position.z - 100

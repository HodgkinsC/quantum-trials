extends Node3D

@export var possible_positions : Array[Vector3]

func teleport(current_building : Node3D, objects : Array):
	# Get Positions
	possible_positions.clear()
	for building : Node3D in get_children():
		if building.global_position != current_building.global_position:
			possible_positions.append(building.global_position)
	# Do Teleport Anim
	var nodes = get_children()
	for node in nodes:
		if node.is_in_group("Building"):
			node.get_node("Door/AnimationPlayer").play("Close")
	await get_tree().create_timer(1).timeout
	for node in nodes:
		if node.is_in_group("Building"):
			node.get_node("OmniLight3D").visible = false
	await get_tree().create_timer(1).timeout
	# Actually Teleport
	
	var new_pos = possible_positions.get(randi_range(0, possible_positions.size() - 1))
	
	for obj : Node3D in objects:
		var offset = current_building.global_position - obj.global_position
		obj.global_position = new_pos - offset + Vector3(0,0.01,0)
	
	# More Animation
	await get_tree().create_timer(1).timeout
	for node in nodes:
		if node.is_in_group("Building"):
			node.get_node("OmniLight3D").visible = true
	for node in nodes:
		if node.is_in_group("Building"):
			node.get_node("Door/AnimationPlayer").play("Open")

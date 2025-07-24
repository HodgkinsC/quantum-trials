extends RayCast3D

@onready var raycast = $"."
@onready var root = get_tree().get_root()
@onready var grabPoint : Node3D = $GrabbingPointNode

# Grabbing System
var grabbed_item : RigidBody3D
var pull_power = 4
var coll : Node3D

func _physics_process(delta: float) -> void:
	
	raycast.force_raycast_update()
	coll = raycast.get_collider()
	if Input.is_action_just_pressed("interact"):
		if coll and !grabbed_item and coll.is_in_group("Grabbable"):
			grabbed_item = coll
			#grabbed_item.reparent(grabPoint)
			grabbed_item.global_rotation.x = 0
			grabbed_item.global_rotation.z = 0
			grabbed_item.axis_lock_angular_x = true
			grabbed_item.axis_lock_angular_z = true
			grabbed_item.set_collision_layer_value(1, false)
		elif grabbed_item:
			#grabbed_item.reparent(Global.current_map)
			grabbed_item.axis_lock_angular_x = false
			grabbed_item.axis_lock_angular_z = false
			grabbed_item.set_collision_layer_value(1, true)
			grabbed_item = null
		if coll and coll.is_in_group("Interactable"):
			coll.use.emit()
	if grabbed_item: 
		grabbed_item.set_linear_velocity((grabPoint.global_position - grabbed_item.global_position) * pull_power * delta * 100)
		grabbed_item.global_rotation.y = move_toward(grabbed_item.global_rotation.y, %Camera3D.global_rotation.y, delta*7)
		grabbed_item.global_rotation.x = move_toward(grabbed_item.global_rotation.x, 0, delta*7)
		grabbed_item.global_rotation.z = move_toward(grabbed_item.global_rotation.z, 0, delta*7)

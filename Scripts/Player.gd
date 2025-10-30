extends CharacterBody3D
class_name Player

@onready var fpscounter = $CanvasLayer/ColorRect/Label

var debug_mode = false
var disabled = false

@onready var camera = %Camera3D

@export var look_sensitivity : float = 0.006
@export var jump_velocity := 4.5
@export var auto_bhop := false

@export var HEADBOB_MOVE_AMOUNT = 0.03
@export var HEADBOB_FREQUENCY = 2.4
var headbob_time := 0.0

# Ground movement settings
@export var walk_speed := 6.0
@export var sprint_speed := 8.5
@export var ground_accel := 14.0
@export var ground_decel := 10.0
@export var ground_friction := 6.0

# Air movement settings
@export var air_cap := 0.85
@export var air_accel := 800.0
@export var air_move_speed := 500.0

var wish_dir := Vector3.ZERO
var cam_aligned_wish_dir := Vector3.ZERO

const CROUCH_TRANSLATE = 0.7
const CROUCH_JUMP_ADD = CROUCH_TRANSLATE * 0.9
var is_crouched := false

var noclip_speed_mult := 3.0
var noclip := false

const MAX_STEP_HEIGHT = 0.3
var _snapped_to_stairs_last_frame = false
var _last_frame_was_on_floor = -INF

@onready var Camera3Dm = %Camera3D
@onready var Headm = %Head
@onready var Flashlightm = %Flashlight
@onready var CamSmoothm = %CamSmooth
@onready var StairCastm = %StairCast
@onready var BelowCastm = %BelowCast

func get_move_speed() -> float:
	if is_crouched:
		return walk_speed * 0.8
	return sprint_speed if Input.is_action_pressed("sprint") else walk_speed

func _ready():
	Global.player = self
	for child in %WorldModel.find_children("*", "VisualInstance3D"):
		child.set_layer_mask_value(1, false)
		child.set_layer_mask_value(2, true)
	$WorldModel.visible = false
	$HeadOriginalPosition/Head/CamSmooth/Camera3D/HeadMesh.visible = false

func _unhandled_input(event):
	if !disabled:
		if Input.is_action_just_pressed("flashlight"):
			Flashlightm.visible = !Flashlightm.visible
		
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			if event is InputEventMouseMotion:
				rotate_y(-event.relative.x * look_sensitivity)
				Camera3Dm.rotate_x(-event.relative.y * look_sensitivity)
				Camera3Dm.rotation.x = clamp(Camera3Dm.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		
		if event is InputEventMouseButton and event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				noclip_speed_mult = min(100.0, noclip_speed_mult * 1.1)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				noclip_speed_mult = max(0.1, noclip_speed_mult * 0.9)

func _headbob_effect(delta):
	headbob_time += delta * self.velocity.length()
	Camera3Dm.transform.origin = Vector3(
		cos(headbob_time * HEADBOB_FREQUENCY * 0.5) * HEADBOB_MOVE_AMOUNT,
		sin(headbob_time * HEADBOB_FREQUENCY) * HEADBOB_MOVE_AMOUNT,
		0
	)

var _saved_camera_global_pos = null
func _save_camera_pos_smoothing():
	if _saved_camera_global_pos == null:
		_saved_camera_global_pos = CamSmoothm.global_position

func _slide_camera_smooth_back_to_origin(delta):
	if _saved_camera_global_pos == null: return
	CamSmoothm.global_position.y = _saved_camera_global_pos.y
	CamSmoothm.position.y = clampf(CamSmoothm.position.y, -0.7, 0.7)
	var move_amount = max(self.velocity.length() * delta, walk_speed/2 * delta)
	CamSmoothm.position.y = move_toward(CamSmoothm.position.y, 0.0, move_amount)
	_saved_camera_global_pos = CamSmoothm.global_position
	if CamSmoothm.position.y == 0:
		_saved_camera_global_pos = null

func _push_away_rigid_bodies():
	pass
	#for i in get_slide_collision_count():
		#var c := get_slide_collision(i)
		#if c.get_collider() is RigidBody3D:
			#var push_dir = -c.get_normal()
			## How much velocity the object needs to increase to match player velocity in the push direction
			#var velocity_diff_in_push_dir = self.velocity.dot(push_dir) - c.get_collider().linear_velocity.dot(push_dir)
			## Only count velocity towards push dir, away from character
			#velocity_diff_in_push_dir = max(0., velocity_diff_in_push_dir)
			## Objects with more mass than us should be harder to push. But doesn't really make sense to push faster than we are going
			#const MY_APPROX_MASS_KG = 80.0
			#var mass_ratio = min(1., MY_APPROX_MASS_KG / c.get_collider().mass)
			## Optional add: Don't push object at all if it's 4x heavier or more
			#if mass_ratio < 0.25:
				#continue
			## Don't push object from above/below
			#push_dir.y = 0
			## 5.0 is a magic number, adjust to your needs
			#var push_force = mass_ratio * 5.0
			#c.get_collider().apply_impulse(push_dir * velocity_diff_in_push_dir * push_force, c.get_position() - c.get_collider().global_position)

func _snap_down_to_stairs_check() -> void:
	var did_snap := false
	var floor_below : bool = BelowCastm.is_colliding() and not is_surface_too_steep(BelowCastm.get_collision_normal())
	var was_on_floor_last_frame = Engine.get_physics_frames() - _last_frame_was_on_floor == 1
	if not is_on_floor() and velocity.y <= 0 and (was_on_floor_last_frame or _snapped_to_stairs_last_frame) and floor_below:
		var body_test_result = PhysicsTestMotionResult3D.new()
		if _run_body_test_motion(self.global_transform, Vector3(0, -MAX_STEP_HEIGHT, 0), body_test_result):
			_save_camera_pos_smoothing()
			var translate_y = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true
	_snapped_to_stairs_last_frame = did_snap

func _snap_up_stairs_check(delta) -> bool:
	if not is_on_floor() and not _snapped_to_stairs_last_frame: return false
	var expected_move_motion = self.velocity * Vector3(1, 0, 1) * delta
	var step_pos_with_clearance = self.global_transform.translated(expected_move_motion + Vector3(0, MAX_STEP_HEIGHT * 2, 0))
	
	var down_check_result = PhysicsTestMotionResult3D.new()
	if (_run_body_test_motion(step_pos_with_clearance, Vector3(0, -MAX_STEP_HEIGHT * 2, 0), down_check_result)) and (down_check_result.get_collider().is_class("StaticBody3D") or down_check_result.get_collider().is_class("CSGShape3D")):
		var step_height = ((step_pos_with_clearance.origin + down_check_result.get_travel()) - self.global_position).y
		
		if step_height > MAX_STEP_HEIGHT or step_height <= 0.01 or (down_check_result.get_collision_point() - self.global_position).y > MAX_STEP_HEIGHT: return false
		StairCastm.global_position = down_check_result.get_collision_point() + Vector3(0, MAX_STEP_HEIGHT, 0) + expected_move_motion.normalized() * 0.1
		StairCastm.force_raycast_update()
		if StairCastm.is_colliding() and not is_surface_too_steep(StairCastm.get_collision_normal()):
			_save_camera_pos_smoothing()
			self.global_position = step_pos_with_clearance.origin + down_check_result.get_travel()
			apply_floor_snap()
			_snapped_to_stairs_last_frame = true
			return true
	return false

@onready var _original_capsule_height = $PlayerColl.shape.height
func _handle_crouch(delta) -> void:
	var was_crouched_last_frame = is_crouched
	if Input.is_action_pressed("crouch"):
		is_crouched = true
	elif is_crouched and not self.test_move(self.transform, Vector3(0, CROUCH_TRANSLATE, 0)):
		is_crouched = false
	
	var translate_y_if_possible := 0.0
	if was_crouched_last_frame != is_crouched and not is_on_floor() and not _snapped_to_stairs_last_frame:
		translate_y_if_possible = CROUCH_JUMP_ADD if is_crouched else -CROUCH_JUMP_ADD
	
	if translate_y_if_possible != 0.0:
		var result = KinematicCollision3D.new()
		self.test_move(self.transform, Vector3(0, translate_y_if_possible, 0), result)
		self.position.y += result.get_travel().y
		Headm.position.y -= result.get_travel().y
		Headm.position.y = clampf(Headm.position.y, -CROUCH_TRANSLATE, 0)
	
	Headm.position.y = move_toward(Headm.position.y, -CROUCH_TRANSLATE if is_crouched else 0, 7.0 * delta)
	$PlayerColl.shape.height = _original_capsule_height - CROUCH_TRANSLATE if is_crouched else _original_capsule_height
	$PlayerColl.position.y = $PlayerColl.shape.height / 2

func _handle_noclip(delta) -> bool:
	if Input.is_action_just_pressed("noclip") and debug_mode:
		noclip = !noclip
	
	$PlayerColl.disabled = noclip
	
	if not noclip:
		return false
	
	var speed = get_move_speed() * noclip_speed_mult
	if Input.is_action_pressed("sprint"):
		speed *= 3.0
	
	self.velocity = cam_aligned_wish_dir * speed
	global_position += self.velocity * delta
	
	return true

func clip_velocity(normal: Vector3, overbounce: float, _delta: float) -> void:
	var backoff := self.velocity.dot(normal) * overbounce
	if backoff >= 0: return
	var change := normal * backoff
	self.velocity -= change
	var adjust := self.velocity.dot(normal)
	if adjust < 0.0:
		self.velocity -= normal * adjust

func is_surface_too_steep(normal: Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > self.floor_max_angle

func _run_body_test_motion(from : Transform3D, motion : Vector3, result = null) -> bool:
	if !result: result= PhysicsTestMotionResult3D.new()
	var params = PhysicsTestMotionParameters3D.new()
	params.from = from
	params.motion = motion
	return PhysicsServer3D.body_test_motion(self.get_rid(), params, result)

func _handle_air_physics(delta) -> void:
	self.velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
	
	var cur_speed_in_wish_dir = self.velocity.dot(wish_dir)
	var capped_speed = min((air_move_speed * wish_dir).length(), air_cap)
	var add_speed_till_cap = capped_speed - cur_speed_in_wish_dir
	if add_speed_till_cap > 0:
		var accel_speed = air_accel * air_move_speed * delta
		accel_speed = min(accel_speed, add_speed_till_cap)
		self.velocity += accel_speed * wish_dir
	
	if is_on_wall():
		if is_surface_too_steep(get_wall_normal()):
			self.motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
		else:
			self.motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED
		clip_velocity(get_wall_normal(), 1, delta)

func _handle_ground_physics(delta) -> void:
	var cur_speed_in_wish_dir = self.velocity.dot(wish_dir)
	var add_speed_until_cap = get_move_speed() - cur_speed_in_wish_dir
	if add_speed_until_cap > 0:
		var accel_speed = ground_accel * delta * get_move_speed()
		accel_speed = min(accel_speed, add_speed_until_cap)
		self.velocity += accel_speed * wish_dir
	
	var control = max(self.velocity.length(), ground_decel)
	var drop = control * ground_friction * delta
	var new_speed = max(self.velocity.length() - drop, 0.0)
	if self.velocity.length() > 0:
		new_speed /= self.velocity.length()
	self.velocity *= new_speed
	
	_headbob_effect(delta)

func _physics_process(delta):
	
	if is_on_floor(): _last_frame_was_on_floor = Engine.get_physics_frames()
	var input_dir = Vector3.ZERO
	if !disabled:
		input_dir = Input.get_vector("left", "right", "forward", "back").normalized()
	# Direction of movement vs direction player is facing
	wish_dir = self.global_transform.basis * Vector3(input_dir.x, 0., input_dir.y)
	cam_aligned_wish_dir = Camera3Dm.global_transform.basis * Vector3(input_dir.x, 0., input_dir.y)
	
	_handle_crouch(delta)
	
	if not _handle_noclip(delta):
		if is_on_floor() or _snapped_to_stairs_last_frame:
			if Input.is_action_just_pressed("jump") or (auto_bhop and Input.is_action_pressed("jump")):
				self.velocity.y = jump_velocity
			_handle_ground_physics(delta)
		else:
			_handle_air_physics(delta)
		
		if not _snap_up_stairs_check(delta):
			_push_away_rigid_bodies()
			move_and_slide()
			_snap_down_to_stairs_check()
	
	_slide_camera_smooth_back_to_origin(delta)
	
	fpscounter.text = "FPS: " + str(Engine.get_frames_per_second())

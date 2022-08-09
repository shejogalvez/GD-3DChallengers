extends KinematicBody

# Mouse sensitivity
const MOUSE_SENSITIVITY := 0.05 
const MAX_VISION_ANGLE := 72
# XZ plane movement
const MAX_SPEED := 28
const ACCEL := 4.5
const DEACCEL := 45.0
# Jumping and gravity
const JUMP_SPEED := 40
const GRAVITY := -80
const MAX_SLOPE_ANGLE := 40
var is_jumping := false
# Sprinting
const MAX_SPRINT_SPEED := 48
const SPRINT_ACCEL := 16
var is_sprinting := false
# Crouching
const MAX_CROUCH_SPEED := 14
const CROUCH_ACCEL := 1.0
const CROUCH_IMPULSE_MULTIPLIER := 1.6
const CROUCH_IMPULSE_MARGIN := 5.0
const CROUCH_LERP := 30
var default_hitbox_height := 10
var crouch_hitbox_height := 3
var is_crouching := false
# Movement vectors
var topdown_direction := Vector2()
var direction := Vector3()
var velocity := Vector3()
# ADS
const ADS_LERP := 20
var default_fov := 90.0
var ads_fov := 60.0

onready var hitbox := $Hitbox
onready var head_pivot := $HeadPivot
onready var head_camera := $HeadPivot/Camera
onready var head_camera_animation_player := $HeadPivot/Camera/AnimationPlayer

# DEBUGGING
var jump_init := Vector3()


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
# Called each frame.
func _physics_process(delta : float) -> void:
	_process_input(delta)
	_process_movement(delta)
	_process_animations(delta)


# Will be where we store all the code relating to player input. We want
# to call it first, before anything else, so we have fresh player input
# to work with.
func _process_input(_delta : float) -> void:
	_process_head_input(_delta)
	
	# Jumping
	if is_jumping and is_on_floor():
		is_jumping = false
		var distance := (global_transform.origin - jump_init).length()
		print("Distance jumped: " + str(distance))
	if Input.is_action_pressed("movement_jump") and is_on_floor():
		velocity.y = JUMP_SPEED
		jump_init = global_transform.origin
		is_jumping = true
		
	# Sprinting
	if Input.is_action_pressed("movement_sprint") and is_on_floor() and !is_crouching and direction:
		is_sprinting = true
	else:
		is_sprinting = false
		
	# Crouching
	if Input.is_action_pressed("movement_crouch"):
		var horizontal_velocity := velocity
		horizontal_velocity.y = 0
		
		if horizontal_velocity.length() >= MAX_SPRINT_SPEED - CROUCH_IMPULSE_MARGIN and !is_crouching:
			velocity.x = velocity.normalized().x * MAX_SPRINT_SPEED * CROUCH_IMPULSE_MULTIPLIER  
			velocity.z = velocity.normalized().z * MAX_SPRINT_SPEED * CROUCH_IMPULSE_MULTIPLIER
		
		hitbox.shape.height -= CROUCH_LERP * _delta
		hitbox.translation.y -= CROUCH_LERP * _delta * 0.5
		head_pivot.translation.y -= CROUCH_LERP * _delta
		is_crouching = true
	elif !_is_on_ceiling():
		hitbox.shape.height += CROUCH_LERP * _delta
		hitbox.translation.y += CROUCH_LERP * _delta * 0.5
		head_pivot.translation.y += CROUCH_LERP * _delta
		if hitbox.shape.height >= default_hitbox_height:
			is_crouching = false

	hitbox.shape.height = clamp(hitbox.shape.height, crouch_hitbox_height, default_hitbox_height)
	hitbox.translation.y = clamp(hitbox.translation.y, hitbox.shape.radius + crouch_hitbox_height * 0.5, hitbox.shape.radius + default_hitbox_height * 0.5)
	head_pivot.translation.y = clamp(head_pivot.translation.y, hitbox.shape.radius + crouch_hitbox_height + 1.0, hitbox.shape.radius + default_hitbox_height + 1.0)
	
	
# Process input if current view is on head camera.
func _process_head_input(_delta : float) -> void:
	# Walking
	direction = Vector3()

	var cam_basis = head_camera.get_global_transform().basis
	var cam_right = cam_basis.x
	var cam_front = cam_basis.z
	cam_front.y = 0
	cam_front = cam_front.normalized()
	
	# The 2D vector representing the player topdown movement.
	topdown_direction = Vector2()
	if Input.is_action_pressed("movement_left"):
		topdown_direction.x -= 1
	if Input.is_action_pressed("movement_right"):
		topdown_direction.x += 1
	if Input.is_action_pressed("movement_forward"):
		topdown_direction.y -= 1
	if Input.is_action_pressed("movement_backward"):
		topdown_direction.y += 1
		
	# Change movement direction by camera plane and inputs.
	direction += cam_front * topdown_direction.y
	direction += cam_right * topdown_direction.x
	direction = direction.normalized()
	
	# ADS
	if Input.is_action_pressed("aim_down_sights"):
		head_camera.fov = lerp(head_camera.fov, ads_fov, ADS_LERP * _delta)
	else:
		head_camera.fov = lerp(head_camera.fov, default_fov, ADS_LERP * _delta)
		
		
# Process player's movement.
func _process_movement(delta : float) -> void:
	
	# Velocity in the horizontal plane XZ.
	var horizontal_velocity := velocity
	horizontal_velocity.y = 0
	
	# Horizontal velocity target 
	var horizontal_velocity_target := direction
	if is_sprinting:
		horizontal_velocity_target *= MAX_SPRINT_SPEED
	elif is_crouching:
		horizontal_velocity_target *= MAX_CROUCH_SPEED
	elif is_on_floor():
		horizontal_velocity_target *= MAX_SPEED
	else:
		var target_speed = max(horizontal_velocity.length(), MAX_SPEED * 0.5)
		horizontal_velocity_target *= target_speed
	
	# Acceleration magnitude
	var acceleration : float
	if is_crouching and horizontal_velocity.length() >= MAX_SPRINT_SPEED - CROUCH_IMPULSE_MARGIN:
		acceleration = CROUCH_ACCEL # Smallest
	elif direction.dot(horizontal_velocity) > 0:
		# The two vectors points towards the same direction.
		if is_sprinting:
			acceleration = SPRINT_ACCEL # Biggest
		else:
			acceleration = ACCEL # Smaller
	else:
		# One is 0 or has a component in the opposite direction of the other.
		# The change of velocity needs to be fast, otherwise "efecto patin".
		acceleration = DEACCEL # Big

	# Velocity adjustment
	var interpolation_weight := min(acceleration * delta, 1.0)
	horizontal_velocity = horizontal_velocity.linear_interpolate(horizontal_velocity_target, interpolation_weight)
	
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
	
	# Affected by gravity
	velocity.y += delta * GRAVITY
	
	# Moves the player and change the velocity according to the collisions.
	var snap = Vector3.DOWN if not is_jumping else Vector3.ZERO
	velocity = move_and_slide_with_snap(velocity, snap, Vector3.UP, true, 4, deg2rad(MAX_SLOPE_ANGLE), false)
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider is RigidBody:
			collision.collider.apply_central_impulse(-collision.normal)


# Process player's animations.
func _process_animations(_delta : float) -> void:
	if is_sprinting:
		head_camera_animation_player.play("head_bob")
	else:
		head_camera_animation_player.stop()


# Called when an input is detected.
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Cursor position relative to last frame.
		var cursor_position = event.relative
		# Rotate player horizontally
		self.rotate_y(deg2rad(cursor_position.x * MOUSE_SENSITIVITY * -1))
		# Rotate head pivot vertically.
		head_pivot.rotate_x(deg2rad(cursor_position.y * MOUSE_SENSITIVITY))
		# Limit the vertical rotation angle.
		head_pivot.rotation.x = clamp(head_pivot.rotation.x, deg2rad(-MAX_VISION_ANGLE), deg2rad(MAX_VISION_ANGLE))


# Returns true if is on ceiling. False otherwise.
func _is_on_ceiling() -> bool:
	return test_move(global_transform, Vector3(0, 2.0, 0))


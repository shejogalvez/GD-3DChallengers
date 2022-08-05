extends KinematicBody

# Mouse sensitivity
const MOUSE_SENSITIVITY := 0.05 
const MAX_VISION_ANGLE := 72
# XZ plane movement
const MAX_SPEED := 28
const ACCEL := 4.5
const DEACCEL := 20
# Jumping and gravity
const JUMP_SPEED := 40
const GRAVITY := -80
const MAX_SLOPE_ANGLE := 40
# Sprinting
const MAX_SPRINT_SPEED := 42
const SPRINT_ACCEL := 16
var is_sprinting := false
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
	if Input.is_action_pressed("movement_jump") and is_on_floor():
		velocity.y = JUMP_SPEED
			
	# Sprinting
	if Input.is_action_pressed("movement_sprint") and direction:
		is_sprinting = true
	else:
		is_sprinting = false
	
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
	var horizontal_velocity = velocity
	horizontal_velocity.y = 0
	
	# Horizontal velocity target 
	var horizontal_velocity_target = direction
	if is_sprinting:
		horizontal_velocity_target *= MAX_SPRINT_SPEED
	else:
		horizontal_velocity_target *= MAX_SPEED
	
	# Acceleration magnitude
	var acceleration
	if direction.dot(horizontal_velocity) > 0:
		# The two vectors points towards the same direction.
		if is_sprinting:
			acceleration = SPRINT_ACCEL # Biggest
		else:
			acceleration = ACCEL # Smallest
	else:
		# One is 0 or has a component in the opposite direction of the other.
		# The change of velocity needs to be fast, otherwise "efecto patin".
		acceleration = DEACCEL # Big

	# Velocity adjustment
	horizontal_velocity = horizontal_velocity.linear_interpolate(horizontal_velocity_target, acceleration * delta)
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
	
	# Affected by gravity
	if !is_on_floor():
		velocity.y += delta * GRAVITY
	
	# If player is affected by any force, moves the player and change the 
	# velocity according to the collisions.
	if direction || velocity.y:
		velocity = move_and_slide(velocity, Vector3.UP, false, 4, deg2rad(MAX_SLOPE_ANGLE), false)
	
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


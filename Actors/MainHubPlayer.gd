extends KinematicBody

# Player nodes
onready var hitbox : CollisionShape = $Hitbox
onready var head_pivot: Spatial = $HeadPivot
onready var head_camera : Camera = $HeadPivot/Camera
onready var skeleton : Skeleton = $Model/PlayerModel/Main/Skeleton
onready var animation_player : AnimationPlayer = $Model/PlayerModel/AnimationPlayer

var MOUSE_SENSITIVITY := 0.05 # Mouse sensitivity
# Movement vectors
var topdown_movement := Vector2()
var dir := Vector3() # The unitary direction vector
var vel := Vector3()
# XZ plane movement
const MAX_SPEED := 28
const ACCEL := 4.5
const DEACCEL := 20
# Jumping and gravity
const JUMP_SPEED := 36
const GRAVITY := -80
const MAX_SLOPE_ANGLE := 40
# Sprinting
const MAX_SPRINT_SPEED := 42
const SPRINT_ACCEL := 16
var is_sprinting := false
# ADS
const ADS_LERP := 20
var default_fov := 90
var ads_fov := 60
# Animations
const HEAD_ANIMATION_LERP := 4
var default_head_camera_position := Vector3(0, 11, 0)
var sprinting_head_camera_position := Vector3(0, 11, 2.8)
var jumping_head_camera_position := Vector3(0, 8, 10.2)

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
# Called each frame.
func _physics_process(delta):
	_process_input(delta)
	_process_movement(delta)
	_process_animations(delta)

# Will be where we store all the code relating to player input. We want
# to call it first, before anything else, so we have fresh player input
# to work with.
func _process_input(_delta : float) -> void:
	_process_head_input(_delta)
	# -----------------------------
	# Jumping
	# -----------------------------
	if is_on_floor():
		if Input.is_action_pressed("movement_jump"):
			vel.y = JUMP_SPEED
	# -----------------------------
	# Sprinting
	# -----------------------------
	if Input.is_action_pressed("movement_sprint"):
		is_sprinting = true
	else:
		is_sprinting = false
	
# Process input if current view is on head camera.
func _process_head_input(_delta : float) -> void:
	# -----------------------------
	# Walking
	# -----------------------------
	# Reset dir.
	dir = Vector3()
	# Vectors representing the camera relative cartesian plane.
	var cam_basis = head_camera.get_global_transform().basis
	var cam_right = cam_basis.x
	var cam_front = cam_basis.z
	cam_front.y = 0
	cam_front = cam_front.normalized()
	# The 2D vector representing the player topdown movement.
	topdown_movement = Vector2()
	if Input.is_action_pressed("movement_left"):
		topdown_movement.x -= 1
	if Input.is_action_pressed("movement_right"):
		topdown_movement.x += 1
	if Input.is_action_pressed("movement_forward"):
		topdown_movement.y -= 1
	if Input.is_action_pressed("movement_backward"):
		topdown_movement.y += 1
	# Change movement direction by camera plane and inputs.
	dir += cam_front * topdown_movement.y
	dir += cam_right * topdown_movement.x
	dir = dir.normalized()
	# -----------------------------
	# ADS
	# -----------------------------
	if Input.is_action_pressed("aim_down_sights"):		
		head_camera.fov = lerp(head_camera.fov, ads_fov, ADS_LERP * _delta)
	else:
		head_camera.fov = lerp(head_camera.fov, default_fov, ADS_LERP * _delta)
		
# Process player's movement.
func _process_movement(delta : float) -> void:
	# Velocity in the horizontal plane XZ.
	var hvel = vel
	hvel.y = 0
	# -----------------------------
	# Horizontal velocity target 
	# -----------------------------
	var hvel_target = dir
	if is_sprinting:
		hvel_target *= MAX_SPRINT_SPEED
	else:
		hvel_target *= MAX_SPEED
	# -----------------------------
	# Accel magnitude
	# -----------------------------
	var accel
	if dir.dot(hvel) > 0:
		# The two vectors points towards the same direction.
		if is_sprinting:
			accel = SPRINT_ACCEL # Biggest
		else:
			accel = ACCEL # Smallest
	else:
		# One is 0 or has a component in the opposite direction of the other.
		# The change of velocity needs to be fast, otherwise "efecto patin".
		accel = DEACCEL # Big
	# -----------------------------
	# Velocity adjustment
	# -----------------------------
	# Change the horizontal velocity to a fraction (determined by accel) 
	# between the current and the target.
	hvel = hvel.linear_interpolate(hvel_target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel.y += delta * GRAVITY
	# Move the player and change the velocity according to the collisions.
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

# Process player's animations.
func _process_animations(_delta : float) -> void:
	head_pivot.transform.origin = head_pivot.transform.origin.linear_interpolate(default_head_camera_position, HEAD_ANIMATION_LERP * _delta)
	if !is_on_floor() and not is_on_wall():
		animation_player.play("Salto Retarget001")
		if vel.y >= 0:
			head_pivot.transform.origin = head_pivot.transform.origin.linear_interpolate(jumping_head_camera_position, HEAD_ANIMATION_LERP * _delta)
		else:
			head_pivot.transform.origin = head_pivot.transform.origin.linear_interpolate(default_head_camera_position, HEAD_ANIMATION_LERP * _delta)
	elif topdown_movement:
		if is_sprinting:
			animation_player.play("Correr estatico Retarget")
			head_pivot.transform.origin = head_pivot.transform.origin.linear_interpolate(sprinting_head_camera_position, HEAD_ANIMATION_LERP * _delta)
		else:
			if topdown_movement[0] < 0:
				animation_player.play("Caminata izquierda Retarget")
			elif topdown_movement[0] > 0:
				animation_player.play("Caminata derecha Retarget")
			else:
				animation_player.play("Caminar Retarget")
	else:
		animation_player.play("Idle Retarget")


# Called when an input is detected.
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Cursor position relative to last frame.
		var cursor_position = event.relative
		# Rotate head pivot vertically.
		head_pivot.rotate_x(deg2rad(cursor_position.y * MOUSE_SENSITIVITY))
		# Rotate player horizontally
		self.rotate_y(deg2rad(cursor_position.x * MOUSE_SENSITIVITY * -1))
		# Limit the vertical rotation angle.
		var head_pivot_rot = head_pivot.rotation_degrees
		head_pivot_rot.x = clamp(head_pivot_rot.x, -64, 64)
		head_pivot.rotation_degrees = head_pivot_rot


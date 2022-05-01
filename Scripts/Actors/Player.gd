extends KinematicBody

# Player nodes
onready var head_pivot: Spatial = $HeadPivot
onready var head_camera : Camera = $HeadPivot/Camera
onready var aimcast : RayCast = $HeadPivot/Camera/AimCast
onready var weapon_pivot : Spatial = $HeadPivot/WeaponPivot
onready var weapon = $HeadPivot/WeaponPivot/Weapon
onready var topdown_pivot : Spatial = $TopDownPivot
onready var topdown_camera : Camera = $TopDownPivot/Camera
onready var crosshair : TextureRect = $Hud/Crossshair
onready var hp_bar : SmartBar = $Hud/HPBar
onready var damage_audio : AudioStreamPlayer = $DamageAudio
# True if viewport is on head camera, false otherwise. 
var is_head_view = false
# The magnitude of grades per frame the topdown view will rotate if
# player presses the correspondent key.
const TOPDOWN_ROTATION_SPEED = 2
# The max distance the topdown camera is going to zoom
const TOPDOWN_MAX_ZOOM = 50
var TOPDOWN_ZOOM_SPEED = 2
# Mouse sensitivity
var MOUSE_SENSITIVITY = 0.05
# The unitary direction vector pointing towards the next frame position
# the player is going to move.
var dir = Vector3()
var vel = Vector3()
# XZ plane movement
const MAX_SPEED = 28
const ACCEL = 4.5
const DEACCEL= 20
# Jumping and gravity
const JUMP_SPEED = 36
const GRAVITY = -80
const MAX_SLOPE_ANGLE = 40
# Sprinting
const MAX_SPRINT_SPEED = 42
const SPRINT_ACCEL = 16
var is_sprinting = false


# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerManager.set_player(self)
	if is_head_view:
		head_camera.make_current()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else: 
		topdown_camera.make_current()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	crosshair.visible = is_head_view # set initial crosshair visibility
	hp_bar.set_smart_value(PlayerManager.get_hp(), PlayerManager.get_total_hp())

# Called each frame.
func _physics_process(delta):
	process_input(delta)
	process_movement(delta)

# Will be where we store all the code relating to player input. We want
# to call it first, before anything else, so we have fresh player input
# to work with.
func process_input(delta):
	if is_head_view:
		process_head_input(delta)
	else:
		process_topdown_input(delta)
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
	# -----------------------------
	# Capturing/Freeing the cursor
	# -----------------------------
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# -----------------------------
	# Shoting
	# -----------------------------
	if Input.is_action_pressed("shot_main") and aimcast.is_colliding():
		weapon.fire_weapon()
	
	
# Process input if current view is on head camera.
func process_head_input(delta):
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
	var topdown_movement = Vector2()
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
	# Changing camera view
	# -----------------------------
	if Input.is_action_just_pressed("change_camera"):
		is_head_view = false
		var head_pivot_rot = head_pivot.rotation_degrees
		head_pivot_rot.x = 0
		head_pivot.rotation_degrees = head_pivot_rot
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		crosshair.visible = false
		topdown_camera.make_current()

# Process input if current view is on topdown camera.
func process_topdown_input(delta):
	# -----------------------------
	# Walking
	# -----------------------------
	# Reset dir.
	dir = Vector3()
	# Vectors representing the camera relative cartesian plane.
	var cam_basis = topdown_camera.get_global_transform().basis
	var cam_right = cam_basis.x
	var cam_up = cam_basis.y * -1
	# The 2D vector representing the player topdown movement.
	var topdown_movement = Vector2()
	if Input.is_action_pressed("movement_left"):
		topdown_movement.x -= 1
	if Input.is_action_pressed("movement_right"):
		topdown_movement.x += 1
	if Input.is_action_pressed("movement_forward"):
		topdown_movement.y -= 1
	if Input.is_action_pressed("movement_backward"):
		topdown_movement.y += 1
	# Change movement direction by camera plane and inputs.
	dir += cam_up * topdown_movement.y
	dir += cam_right * topdown_movement.x
	dir = dir.normalized()
	# Save pivot transformation.
	var pivot_transf = topdown_pivot.get_global_transform()
	# Rotate player towards mouse position if clicked. Otherwise, rotate
	# towards movement direction (camera is rotated in 180).
	if Input.is_action_pressed("shot_main"):
		var mouse_pos = get_viewport().get_mouse_position() - get_viewport().get_visible_rect().size * 0.5
		var mouse_dir = Vector3(mouse_pos.x, 0, mouse_pos.y).normalized()
		mouse_dir = pivot_transf.xform(mouse_dir) - pivot_transf.origin
		self.look_at(self.translation + mouse_dir, Vector3(0, 1, 0))
	elif dir != Vector3():
		self.look_at(self.translation + (dir * -1) , Vector3(0, 1, 0))
	# Reset pivot transformation.
	topdown_pivot.set_global_transform(pivot_transf)
	# -----------------------------
	# Rotating topdown camera
	# -----------------------------
	if Input.is_action_pressed("td_rotate_clockwise"):
		topdown_pivot.rotate_y(deg2rad(-TOPDOWN_ROTATION_SPEED))
	if Input.is_action_pressed("td_rotate_counterclockwise"):
		topdown_pivot.rotate_y(deg2rad(TOPDOWN_ROTATION_SPEED))
	# -----------------------------
	# Zoom camera
	# -----------------------------
	var topdown_zoom_distance = topdown_camera.translation.y
	if Input.is_action_just_released("td_zoom_in") and topdown_zoom_distance > -TOPDOWN_MAX_ZOOM:
		topdown_camera.global_translate(Vector3.DOWN * TOPDOWN_ZOOM_SPEED)
	if Input.is_action_just_released("td_zoom_out") and topdown_zoom_distance < 0:
		topdown_camera.global_translate(Vector3.UP * TOPDOWN_ZOOM_SPEED)
	# -----------------------------
	# Changing camera view
	# -----------------------------
	if Input.is_action_just_pressed("change_camera"):
		is_head_view = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		head_camera.make_current()
		crosshair.visible = true
		
# Process player's movement.
func process_movement(delta):
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
		head_pivot_rot.x = clamp(head_pivot_rot.x, -72, 72)
		head_pivot.rotation_degrees = head_pivot_rot

# Changes the player weapon node.
func change_weapon(weapon_node):
	weapon.queue_free()
	weapon_pivot.add_child(weapon_node)
	weapon = weapon_node

# Updates the hp bar value.
func update_hp_bar():
	hp_bar.set_smart_value(PlayerManager.get_hp(), PlayerManager.get_total_hp())

# Plays the damage audio.
func play_damage_audio():
	damage_audio.play()

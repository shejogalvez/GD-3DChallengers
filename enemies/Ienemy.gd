extends KinematicBody
class_name IEnemy

export (int) var hp = 0
var alerted : bool
export (int) var speed = 18
export (int, -200, 0) var gravity = -80
export (int, 0, 300) var attack_distance = 15
export (int, 0, 300) var lose_distance = 150
onready var raycast = $RayCast

var state
var standbyState = Standby.new()
var alertedState = Alerted.new()
export (int) var alert_range = 25

func _ready():
	set_state(standbyState)
	pass # Replace with function body.
	
func attack():
	pass
	
func found_player():
	set_state(alertedState)
	
func lose_player():
	set_state(standbyState)

func projectile_hit(damage, bullet_global_trans):
	state.projectile_hit(damage, bullet_global_trans)

func _process(delta):
	state._process(delta)
	
func _physics_process(delta):
	state._physics_process(delta)
	
func set_state(state):
	self.state = state
	state.start(self)

# useful functions
func vec_to_player() -> Vector3:
	return -(self.global_transform.origin - PlayerManager.get_player_position())
	
func vec_to_player2d():
	var vec3d = -(self.global_transform.origin - PlayerManager.get_player_position())
	return Vector3(vec3d.x, 0, vec3d.z)
	
func vec_to_player_face(self_face):
	return -(self_face.global_transform.origin - PlayerManager.get_player_face_position())
	
func face_player():
	var dir : Vector3 = vec_to_player2d()
	var angle;
	var back : Vector3 
#	if self.get_parent_spatial() != null:
#		back = -get_parent().global_transform.basis.z
#		print(get_parent(), get_parent().angle)
#	else:
#		back = Vector3.FORWARD
#	if dir.x > 0:
#		angle = -back.angle_to(dir)
#	else:
#		angle = back.angle_to(dir)
	angle = dir.angle_to(global_transform.basis.z)
	if global_transform.basis.x.dot(dir) > 0:
		rotate_y(angle)
	else: rotate_y(-angle)
	#look_at(PlayerManager.get_player_position(), Vector3.UP)
	#self.rotation.y += PI

func set_ray_castdir():
	var rotation = -global_transform.basis.get_euler().y
	raycast.cast_to = vec_to_player().normalized().rotated(Vector3.UP, rotation) * alert_range
	#print(raycast.cast_to)

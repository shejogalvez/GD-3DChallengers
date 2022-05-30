extends KinematicBody
class_name IEnemy

export (int) var hp = 0
var alerted : bool
export (int) var speed = 18
export (int, -200, 0) var gravity = -80
export (int, 0, 300) var attack_distance = 15
onready var raycast = $RayCast

var state
export (int) var alert_range = 50

func _ready():
	set_state(Standby.new())
	pass # Replace with function body.
	
func attack():
	pass

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
func vec_to_player():
	return -(self.global_transform.origin - PlayerManager.get_player_position())
	
func vec_to_player2d():
	var vec3d = -(self.global_transform.origin - PlayerManager.get_player_position())
	return Vector3(vec3d.x, 0, vec3d.z)
	
func vec_to_player_face(self_face):
	return -(self_face.global_transform.origin - PlayerManager.get_player_face_position())
	
func face_player():
	var dir : Vector3 = vec_to_player2d()
	var angle;
	if dir.x > 0:
		angle = Vector3.BACK.angle_to(dir)
	else:
		angle = -Vector3.BACK.angle_to(dir)
	self.rotation.y = angle

func set_ray_castdir():
	raycast.cast_to = vec_to_player().normalized() * alert_range
	#print(raycast.cast_to)

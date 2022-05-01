extends Projectile

var initial_angle = Quat.IDENTITY
var forward_dir = Vector3()

func _ready():
	projectile_damage = 18
	projectile_speed = 40
	kill_timer = 8
	
func impact(body):
	if hit_something == false:
		if body == PlayerManager.get_player():
			PlayerManager.receive_damage(projectile_damage)
			queue_free()
	hit_something = true

func _move_projectile(delta):
	#var forward_dir = -global_transform.basis.z.normalized()
	global_translate(forward_dir * projectile_speed * delta)
	
func set_inital_angle(angle):
	initial_angle = angle
	
func set_forward_dir(vector):
	forward_dir = vector

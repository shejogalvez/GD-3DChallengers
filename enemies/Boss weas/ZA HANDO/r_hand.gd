extends Weapon

var BULLET_NUMBER = 1
var ATTACK_CD = 7

var accel = 0.5
var time = 0
var target_pos = 0
var pos = 0

var vec_dif : Vector3

func _ready():
	projectiles = BULLET_NUMBER
	fire_cd = ATTACK_CD
	
	
# Called each frame
func _physics_process(delta):
	current_fire_cd -= delta
	if time + delta > fposmod((5 + delta), 5):
		pos = target_pos
		target_pos = rand_range(-3, 6)
		
	var displace = (target_pos - pos) * accel * delta
	translate(Vector3(displace, 0, 0))
	pos += displace
	time += delta
	
	self.transform.origin.y += cos(time)*0.005
func _set_projectile_transform(projectile, _projectile_id):
	
	projectile.scale = Vector3(5, 5, 5)
	projectile.global_transform = barrel.global_transform
	
	if vec_dif.x > 0:
		projectile.rotate_y(-Vector3.FORWARD.angle_to(vec_dif))
	else:
		projectile.rotate_y(Vector3.FORWARD.angle_to(vec_dif))
	

func _fire():
	var dif = PlayerManager.get_player_position() - barrel.global_transform.origin
	vec_dif = Vector3(dif[0], 0, dif[2])
	for projectile_id in projectiles:
		var projectile = projectile_scene.instance()
		var scene_root = get_tree().root.get_children()[0]
		scene_root.add_child(projectile)
		_set_projectile_transform(projectile, projectile_id)

func fire_weapon():
	if current_fire_cd <= 0:
		_fire()
		current_fire_cd = fire_cd

extends EnemyWeapon

export (float) var BULLET_SEPARATION = 9
export (float) var BULLET_OFSET = 5
export (float) var BULLET_NUMBER = 15
export (float) var ATTACK_CD = 1.5

var accel = 0.5
var time = 0
var target_pos = 0
var pos = 0

var vec_dif : Vector3

	
func _ready():
	projectiles = BULLET_NUMBER
	fire_cd = ATTACK_CD
	
func _set_projectile_transform(projectile, projectile_id):
	projectile.global_transform = barrel.global_transform
	
	projectile.scale = Vector3(5, 5, 5)
	projectile.global_transform = barrel.global_transform
	var off = rand_range(-BULLET_OFSET, BULLET_OFSET)
	
	var total_spectrum = BULLET_SEPARATION * (projectiles - 1)
	var initial_rotation = - total_spectrum / 2
	var rotation_from_initial = projectile_id * BULLET_SEPARATION + off
	var final_rotation = initial_rotation + rotation_from_initial
	
	projectile.set_forward_dir(vec_dif.rotated(Vector3.UP, deg2rad(final_rotation)))
	
func _physics_process(delta):
	._physics_process(0)
	if time + delta > fposmod((5 + delta), 5):
		pos = target_pos
		target_pos = rand_range(-6, 3)
		
	var displace = (target_pos - pos) * accel * delta
	translate(Vector3(displace, 0, 0))
	pos += displace
	time += delta
	
func set_fire(bullets):
	self.projectiles = bullets
	_fire3d()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _fire():
	var dif = PlayerManager.get_player_position() -self.global_transform.origin
	vec_dif = Vector3(dif[0], 0, dif[2]).normalized()
	for projectile_id in projectiles:
		var projectile = projectile_scene.instance()
		get_parent().add_child(projectile)
		_set_projectile_transform(projectile, projectile_id)


func _fire3d():
	var dif = PlayerManager.get_player_position() -self.global_transform.origin
	vec_dif = dif.normalized()
	for projectile_id in projectiles:
		var projectile = projectile_scene.instance()
		get_parent().add_child(projectile)
		_set_projectile_transform(projectile, projectile_id)

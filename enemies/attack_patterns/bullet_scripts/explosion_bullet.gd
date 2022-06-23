extends EnemyBullet

export (PackedScene) var subbullet_scene : PackedScene = preload("res://enemies/attack_patterns/bullet_scenes/remi_bullet.tscn")
export (float) var time_between_bullets = 0.3
var n_bullets = 10
var bullet_index = 0
export (float) var max_size : float = 40
export (Curve) var size_curve : Curve
export var gradient_move_time_offset = 2
var inverse_killtimer = 1 / kill_timer

var mesh : MeshInstance
var scene_root : Node


func _ready():
	mesh = $Model
	mesh.get_active_material(0).set_shader_param("time_offset", gradient_move_time_offset)
	mesh.get_active_material(0).set_shader_param("pos_by_time", 1 / (kill_timer - gradient_move_time_offset) )
	if PlayerManager.get_player() != null:
		scene_root = PlayerManager.get_player().get_parent()
	else:
		scene_root = get_parent()
	

func _process(delta):
	while timer > bullet_index * time_between_bullets:
		var initial_angle = rand_range(0, 2*PI)
		var angle_dif = (2*PI/n_bullets)
		for i in range(n_bullets):
			var bullet = subbullet_scene.instance()
			bullet.bullet_speed_curve = size_curve
			bullet.max_speed = 30
			_bullet_transform(bullet, initial_angle + i * angle_dif)
			scene_root.add_child(bullet)
		bullet_index += 1
	self.scale = Vector3.ONE * size_curve.interpolate(inverse_killtimer * timer) * max_size
	mesh.get_active_material(0).set_shader_param("time", timer)
	
func impact(body):
	if body == PlayerManager.get_player():
		PlayerManager.receive_damage(projectile_damage)
	
func _bullet_transform(bullet, angle):
	bullet.rotate_y(angle)
	bullet.scale = Vector3(3, 3, 3)
	bullet.global_transform = self.global_transform
	
# Moves the projectile.
func _move_projectile(_delta : float) -> void:
	pass

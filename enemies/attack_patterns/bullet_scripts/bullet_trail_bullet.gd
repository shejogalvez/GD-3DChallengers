extends EnemyBullet

export (PackedScene) var subbullet_scene : PackedScene = preload("res://enemies/attack_patterns/bullet_scenes/remi_bullet.tscn")
export (float) var time_between_bullets = 0.05
var bullet_index = 0
var dir_to_player : Vector3 = Vector3.ZERO


func _process(delta):
	while timer > bullet_index * time_between_bullets:
		var bullet = subbullet_scene.instance()
		var scene_root = get_parent()
		scene_root.add_child(bullet)
		_bullet_transform(bullet)
		bullet_index += 1


func _bullet_transform(bullet):
	var angle = rand_range(0, 2*PI)
	bullet.rotate_y(angle)
	bullet.scale = Vector3(3, 3, 3)
	bullet.global_transform = self.global_transform
	
# Moves the projectile.
func _move_projectile(delta : float) -> void:
	var forward_dir = dir_to_player
	global_translate(forward_dir * projectile_speed * delta)
	
func set_dir_to_player(vec3):
	dir_to_player = vec3

	

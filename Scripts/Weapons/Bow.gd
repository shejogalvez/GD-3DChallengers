extends Weapon

export(float, 0, 30) var SEPARATION_ANGLE = 10

# Sets the 
func _set_projectile_transform(projectile, projectile_id):
	projectile.global_transform = barrel.global_transform
	var total_spectrum = SEPARATION_ANGLE * (projectiles - 1)
	var initial_rotation = - total_spectrum / 2
	var rotation_from_initial = projectile_id * SEPARATION_ANGLE
	projectile.rotate_y(deg2rad(initial_rotation + rotation_from_initial))

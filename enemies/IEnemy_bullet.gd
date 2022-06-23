extends Projectile
class_name EnemyBullet

export (int) var damage = 18
export (int) var max_speed = 60

func _ready():
	projectile_damage = damage
	
func impact(body):
	if hit_something == false:
		if body == PlayerManager.get_player():
			PlayerManager.receive_damage(projectile_damage)
			queue_free()
	hit_something = true

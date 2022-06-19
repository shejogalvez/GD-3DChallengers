extends Projectile
class_name EnemyBullet

export (Curve) var bullet_speed_curve : Curve
export (int) var damage = 18
export (int) var max_speed = 60
var inverse_killtimer

func _ready():
	projectile_damage = damage
	inverse_killtimer = 1/kill_timer
	
func impact(body):
	if hit_something == false:
		if body == PlayerManager.get_player():
			PlayerManager.receive_damage(projectile_damage)
			queue_free()
	hit_something = true

	
func _physics_process(delta):
	projectile_speed = bullet_speed_curve.interpolate(timer * inverse_killtimer) * max_speed
	._physics_process(0)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

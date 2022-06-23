extends EnemyBullet
class_name CurveSpeedBullet

export (Curve) var bullet_speed_curve : Curve
var inverse_killtimer

func _ready():
	inverse_killtimer = 1/kill_timer

func _physics_process(delta):
	projectile_speed = bullet_speed_curve.interpolate(timer * inverse_killtimer) * max_speed
	._physics_process(0)

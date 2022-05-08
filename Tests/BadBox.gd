extends RigidBody

func _ready():
	pass

func projectile_hit(damage, bullet_global_trans):
	queue_free()

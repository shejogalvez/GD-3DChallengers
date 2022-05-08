extends RigidBody

func _ready():
	pass

func bullet_hit(damage, bullet_global_trans):
	queue_free()

extends State
class_name Alerted

# default alerted = follow
var vel = Vector3.ZERO
var actual_speed = 0
const MAX_SLOPE_ANGLE = 40

func _physics_process(delta):
		var direction : Vector3 = enemy_node.vec_to_player().normalized()
		actual_speed = min(actual_speed + enemy_node.accel * delta, enemy_node.speed)
		vel.x = direction.x*actual_speed
		vel.z = direction.z*actual_speed
		
		vel.y += enemy_node.gravity * delta
		vel = enemy_node.move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

func _process(delta):
		if not alerted:
			var dif = enemy_node.global_transform.origin - PlayerManager.get_player_position()
			if dif.length() < enemy_node.attack_distance:
				enemy_node.attack()
				alerted = true
			elif dif.length() > enemy_node.lose_distance:
				enemy_node.lose_player()

func projectile_hit(damage, trans):
	.projectile_hit(damage, trans)
	actual_speed = 0

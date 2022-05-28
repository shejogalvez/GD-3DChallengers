extends State
class_name Alerted

# default alerted = follow
var vel = Vector3.ZERO
const MAX_SLOPE_ANGLE = 40

func _physics_process(delta):
		var direction : Vector3 = enemy_node.vec_to_player().normalized()
		vel.x = direction.x*enemy_node.speed
		vel.z = direction.z*enemy_node.speed
		
		vel.y += enemy_node.gravity * delta
		vel = enemy_node.move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

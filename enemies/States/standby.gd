extends State
class_name Standby

func _process(delta):
	enemy_node.set_ray_castdir()
	var object = raycast.get_collider()
	if object!=null:
		if object == PlayerManager.get_player():
			enemy_node.found_player()
		
	

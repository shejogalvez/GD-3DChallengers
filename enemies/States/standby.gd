extends State
class_name Standby

func _process(delta):
	var body = raycast.get_collider()
	if body.get_type() == Player:
		enemy_node.set_state(Alerted.new())
		
	

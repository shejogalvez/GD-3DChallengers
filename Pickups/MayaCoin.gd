extends Pickup

# Tells if the pickup is pickable or not
func _is_pickable(): 
	var distance = global_transform.origin - PlayerManager.get_player_position()
	

# Called when the players pick up the pickup
func _obtain():
	PlayerManager.add_money(15)

extends Pickup

# Called when the player interacts with the pickup.
func _obtain():
	PlayerManager.add_money(10)

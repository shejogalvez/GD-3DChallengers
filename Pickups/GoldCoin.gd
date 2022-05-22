extends Pickup

# Called when the player interacts with the pickup.
func _obtain() -> void:
	PlayerManager.add_money(1)

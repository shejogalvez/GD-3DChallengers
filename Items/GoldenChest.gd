extends Item

# Called when the player uses the item.
func use() -> void:
	PlayerManager.add_money_multiplier(0.5)

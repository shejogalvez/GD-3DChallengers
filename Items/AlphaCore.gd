extends Item

# Called when the player uses the item.
func use() -> void:
	PlayerManager.add_consumable_multiplier(1.0)

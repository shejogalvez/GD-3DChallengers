extends Item

# Called when the player uses the item.
func use() -> void:
	PlayerManager.add_consumables_total_size(1)

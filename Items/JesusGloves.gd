extends Item

# Called when the player uses the item.
func use() -> void:
	PlayerManager.get_weapon().add_projectile()

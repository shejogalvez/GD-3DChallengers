extends Item

func use():
	PlayerManager.get_weapon().add_projectile()

extends Item

func use():
	Player_Manager.get_weapon().add_projectile()

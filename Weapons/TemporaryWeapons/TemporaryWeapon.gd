extends Weapon
class_name TemporaryWeapon

export(int, 0, 10) var uses := 1
var current_use := 0

var previous_weapon : Weapon

# Fires the weapon.
func _post_fire() -> void:
	current_use += 1
	if current_use == uses:
		PlayerManager.set_weapon(previous_weapon)

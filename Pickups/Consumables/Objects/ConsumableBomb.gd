extends Consumable

var bomb_weapon_scene : PackedScene = preload("res://Weapons/TemporaryWeapons/BombWeapon.tscn") 
var equip_audio : AudioStream = load("res://Assets/Audio/bomb-equip.wav")

# Consumes the consumable.
func consume() -> void:
	if not PlayerManager.get_weapon().is_class("TemporaryWeapon"):
		PlayerManager.set_temporary_weapon(bomb_weapon_scene.instance())
		AudioStreamManager.play(equip_audio)

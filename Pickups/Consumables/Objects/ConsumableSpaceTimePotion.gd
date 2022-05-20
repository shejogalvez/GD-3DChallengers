extends Consumable

var potion_audio : AudioStream = load("res://Assets/Audio/potion_drink.wav")

# Consumes the consumable.
func consume():
	PlayerManager.heal(PlayerManager.get_consumable_multiplier() * 100)
	PlayerManager.add_temporary_attack(PlayerManager.get_consumable_multiplier() * 50, 7)
	PlayerManager.add_temporary_defense(PlayerManager.get_consumable_multiplier() * 50, 7)
	AudioStreamManager.play(potion_audio)

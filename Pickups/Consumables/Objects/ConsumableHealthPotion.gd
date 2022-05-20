extends Consumable

var potion_audio : AudioStream = load("res://Assets/Audio/potion-drink.wav")

# Consumes the consumable.
func consume():
	PlayerManager.heal(PlayerManager.get_consumable_multiplier() * 100)
	AudioStreamManager.play(potion_audio)

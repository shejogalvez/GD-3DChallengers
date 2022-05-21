extends Consumable

var potion_audio : AudioStream = load("res://Assets/Audio/bomb-equip.wav")

# Consumes the consumable.
func consume() -> void:
	PlayerManager.heal(PlayerManager.get_consumable_multiplier() * 100)
	AudioStreamManager.play(potion_audio)
 

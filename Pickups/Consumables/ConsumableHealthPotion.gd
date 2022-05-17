extends Consumable

var consume_audio : AudioStream = load("res://Assets/Audio/potion_drink.wav")

# Consumes the consumable.
func consume():
	PlayerManager.heal(100)
	AudioStreamManager.play(consume_audio)

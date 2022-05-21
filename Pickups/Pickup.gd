extends RigidBody
class_name Pickup, "res://Assets/Classes/pickup_icon.png"

export(AudioStream) var pickup_audio

onready var interaction : Interaction = $Interaction

# Interact function used by the interaction node.
func interact() -> void:
	AudioStreamManager.play(pickup_audio)
	_obtain()
	queue_free()
	
# Called when the player interacts with the pickup.
func _obtain() -> void:
	pass

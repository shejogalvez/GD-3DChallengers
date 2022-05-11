extends RigidBody
class_name Pickup, "res://Assets/Classes/pickup_icon.png"

export(AudioStream) var pickup_audio

onready var interaction : Interaction = $Interaction

# Interact function used by the interaction node.
func interact():
	AudioStreamManager.play_3d(pickup_audio, global_transform.origin, get_parent())
	_obtain()
	queue_free()
	
# Called when the player interacts with the pickup.
func _obtain():
	pass

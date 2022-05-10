extends RigidBody
class_name Pickup

export(AudioStream) var pickup_audio

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact"):
		if _is_pickable():
			AudioStreamManager.play(pickup_audio, get_parent())
			_obtain()
			queue_free()

# Tells if the pickup is pickable or not
func _is_pickable():
	return true

# Called when the players pick up the pickup
func _obtain():
	pass

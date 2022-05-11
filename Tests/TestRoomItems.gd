extends Spatial

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()

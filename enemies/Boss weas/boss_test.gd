extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func _process(delta):
	
	if Input.is_key_pressed(KEY_R):
		delete_children(self)
		get_tree().reload_current_scene()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

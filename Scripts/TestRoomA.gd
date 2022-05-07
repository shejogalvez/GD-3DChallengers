
extends Node

var total_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	total_time += delta
	
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
		
	if get_tree().get_nodes_in_group("enemies").empty():
		print("You have killed all enemies! Total time: " + str(total_time))
		get_tree().reload_current_scene()

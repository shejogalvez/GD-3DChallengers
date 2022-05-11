extends Node

var interactions = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): 
	if Input.is_action_just_pressed("interact") and not interactions.empty():
		interactions[0].interact()
		
func add_interaction(interaction : Interaction):
	interactions.append(interaction)
	update_interaction_gui()

func remove_interaction(interaction : Interaction):
	interactions.erase(interaction)
	update_interaction_gui()
	
func update_interaction_gui():
	pass
	
	

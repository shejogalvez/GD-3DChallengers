extends Node

var interactions = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): 
	if Input.is_action_just_pressed("interact") and not interactions.empty():
		interactions.back().interact()
		
func add_interaction(interaction : Interaction):
	if not interactions.empty():
		interactions.back().unmark()
	interactions.append(interaction)
	interaction.mark()
	update_interaction_gui()

func remove_interaction(interaction : Interaction):
	interaction.unmark()
	interactions.erase(interaction)
	if not interactions.empty():
		interactions.back().mark()
	update_interaction_gui()
	
func update_interaction_gui():
	pass
	
	

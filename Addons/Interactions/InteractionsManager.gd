extends Node

# Signal called when the interaction stack is updated.
signal interactions_updated

var interactions = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): 
	if Input.is_action_just_pressed("interact") and not interactions.empty():
		interactions.back().interact()
		
# Adds an interaction to the stack.
func add_interaction(interaction : Interaction):
	interactions.append(interaction)
	emit_signal("interactions_updated")

# Removes an interaction from the stack.
func remove_interaction(interaction : Interaction):
	interactions.erase(interaction)
	emit_signal("interactions_updated")

# Returns true if there is no interactions in the stack, false otherwise.
func no_interactions() -> bool:
	return interactions.empty()

# Gets the last interaction in the stack.
func get_last_interaction() -> Interaction:
	return interactions.back()

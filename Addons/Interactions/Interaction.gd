extends Area
class_name Interaction

export(StreamTexture) var interaction_icon 
export(String) var interaction_message = "Interact"

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "add_to_manager")
	connect("body_exited", self, "remove_from_manager")

# Interacts with the node.
func interact() -> void:
	if get_parent().has_method("interact"):
		get_parent().interact()

# Adds this interaction to the interaction manager.
func add_to_manager(_body : KinematicBody) -> void:
	InteractionsManager.add_interaction(self)
	
# Removes this interaction from the interaction manager.
func remove_from_manager(_body : KinematicBody) -> void:
	InteractionsManager.remove_interaction(self)

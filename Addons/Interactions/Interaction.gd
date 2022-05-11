extends Area
class_name Interaction

export(String) var interaction_message = "Interact"

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "add_to_manager")
	connect("body_exited", self, "remove_from_manager")

# Interacts with the node
func interact() -> void:
	if get_parent().has_method("interact"):
		get_parent().interact()

func add_to_manager(body : KinematicBody) -> void:
	if body == PlayerManager.get_player():
		InteractionsManager.add_interaction(self)
	
func remove_from_manager(body : KinematicBody) -> void:
	if body == PlayerManager.get_player():
		InteractionsManager.remove_interaction(self)

extends StaticBody

onready var workstation_gui = $WorkstationScreen/Viewport/Workstation

# Interacts with the node.
func interact() -> void:
		workstation_gui.get_parent().remove_child(workstation_gui)
		get_parent().add_child(workstation_gui)

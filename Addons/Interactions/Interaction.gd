extends Area
class_name Interaction

export(String) var interaction_message = "Interact"

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "add_to_manager")
	connect("body_exited", self, "remove_from_manager")
	var material = SpatialMaterial.new()
	$Viewport/Panel/Label.text = interaction_message
	# Always looks towards the camera
	material.params_billboard_mode = SpatialMaterial.BILLBOARD_ENABLED
	# Enable transparent color rendering
	material.flags_transparent = true
	material.albedo_texture = $Viewport.get_texture()
	$MessageModel.set_surface_material(0, material)

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

func mark():
	$MessageModel.show()
	
func unmark():
	$MessageModel.hide()

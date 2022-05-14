extends CanvasLayer

onready var crosshair : TextureRect = $Crossshair
onready var hp_bar : SmartBar = $HPBar
onready var interaction_panel = $InteractionPanel
onready var interaction_panel_message = $InteractionPanel/HBoxContainer/Label
onready var interaction_panel_icon = $InteractionPanel/HBoxContainer/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_panel.hide()
	InteractionsManager.connect("interactions_updated", self, "_update_interaction_panel")
	PlayerManager.connect("hp_changed", self, "update_hp_bar")

# Shows the crosshair.
func show_crosshair():
	crosshair.show()
	
# Hides the crosshair.
func hide_crosshair():
	crosshair.hide()
	
# Updates the hp bar.
func update_hp_bar():
	hp_bar.set_smart_value(PlayerManager.get_hp(), PlayerManager.get_total_hp())

# Updates the interaction panel.
func _update_interaction_panel():
	if (InteractionsManager.no_interactions()):
		interaction_panel.hide()
	else:
		var interaction = InteractionsManager.get_last_interaction()
		interaction_panel_icon.texture = interaction.interaction_icon
		interaction_panel_message.text = interaction.interaction_message
		interaction_panel.show()

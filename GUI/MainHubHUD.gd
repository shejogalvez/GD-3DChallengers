extends Control

onready var interaction_panel := $InteractionPanel
onready var interaction_icon := $InteractionPanel/InteractionIcon
onready var interaction_message := $InteractionPanel/InteractionMessage
onready var animation_player := $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_interaction_panel()
	InteractionsManager.connect("interactions_updated", self, "_update_interaction_panel")
	

# Updates the interaction panel.
func _update_interaction_panel():
	if (InteractionsManager.interactions_empty()):
		interaction_panel.hide()
		animation_player.stop()
	else:
		var interaction = InteractionsManager.get_last_interaction()
		interaction_icon.texture = interaction.interaction_icon
		interaction_message.text = interaction.interaction_message
		interaction_panel.show()
		animation_player.play("interaction_beat")

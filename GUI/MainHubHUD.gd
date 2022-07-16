extends Control

onready var fps_label := $FPSLabel
onready var interaction_panel := $InteractionPanel
onready var interaction_icon := $InteractionPanel/InteractionIcon
onready var interaction_message := $InteractionPanel/InteractionMessage
onready var animation_player := $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_interaction_panel()
	InteractionsManager.connect("interactions_updated", self, "_update_interaction_panel")
	
# Called every frame.
func _process(delta):
	fps_label.text = str(Engine.get_frames_per_second()) + " FPS"

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

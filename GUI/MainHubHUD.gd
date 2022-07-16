extends Control

onready var fps_label := $FPSLabel
onready var day_label := $DayLabel
onready var money_label := $MoneyControl/MoneyLabel
onready var interaction_panel := $InteractionPanel
onready var interaction_icon := $InteractionPanel/InteractionIcon
onready var interaction_message := $InteractionPanel/InteractionMessage
onready var interaction_animation_player := $InteractionAnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	day_label.text = "Day " + str(GameManager.game_data["game"]["day"])
	money_label.text = str(GameManager.game_data["game"]["money"])
	
	_update_interaction_panel()
	InteractionsManager.connect("interactions_updated", self, "_update_interaction_panel")
	
# Called every frame.
func _process(delta):
	fps_label.text = str(Engine.get_frames_per_second()) + " FPS"

# Updates the interaction panel.
func _update_interaction_panel():
	if (InteractionsManager.interactions_empty()):
		interaction_panel.hide()
		interaction_animation_player.stop()
	else:
		var interaction = InteractionsManager.get_last_interaction()
		interaction_icon.texture = interaction.interaction_icon
		interaction_message.text = interaction.interaction_message
		interaction_panel.show()
		interaction_animation_player.play("interaction_beat")

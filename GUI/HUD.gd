extends Control

onready var crosshair : TextureRect = $Crossshair
onready var hp_bar : SmartBar = $HPBar
onready var money_panel = $MoneyPanel
onready var money_label = $MoneyPanel/MoneyLabel
onready var consumables_control = $ConsumablesControl
onready var interaction_panel = $InteractionPanel
onready var interaction_icon = $InteractionPanel/InteractionIcon
onready var interaction_message = $InteractionPanel/InteractionMessage
onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_crosshair()
	_update_hp_bar()
	_update_money_panel()
	_update_consumables_panel()
	_update_interaction_panel()
	PlayerManager.connect("view_changed", self, "_update_crosshair")
	PlayerManager.connect("hp_changed", self, "_update_hp_bar")
	PlayerManager.connect("money_changed", self, "_update_money_panel")
	PlayerManager.connect("consumables_updated", self, "_update_consumables_panel")
	InteractionsManager.connect("interactions_updated", self, "_update_interaction_panel")
	
# Shows the crosshair.
func _update_crosshair():
	if PlayerManager.is_head_view():
		crosshair.show()
	else:
		crosshair.hide()
	
# Updates the hp bar.
func _update_hp_bar():
	hp_bar.set_smart_value(PlayerManager.get_hp(), PlayerManager.get_total_hp())

# Updates the money panel.
func _update_money_panel():
	money_label.text = str(PlayerManager.get_money())

# Updates the consumables panel.
func _update_consumables_panel():
	if (PlayerManager.consumables_empty()):
		consumables_control.hide()
	else:
		for consumable_icon_id in consumables_control.get_child_count(): 
			var consumable_icon : TextureRect = consumables_control.get_child(consumables_control.get_child_count() - consumable_icon_id - 1)
			if PlayerManager.get_consumable(consumable_icon_id) != null:
				consumable_icon.texture = PlayerManager.get_consumable(consumable_icon_id).consumable_icon
				consumable_icon.show()
			else:
				consumable_icon.hide()
		consumables_control.show()

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

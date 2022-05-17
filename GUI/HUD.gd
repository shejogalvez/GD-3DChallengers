extends CanvasLayer

onready var crosshair : TextureRect = $Crossshair
onready var hp_bar : SmartBar = $HPBar
onready var money_panel = $MoneyPanel
onready var money_label = $MoneyPanel/MoneyLabel
onready var consumables_panel = $ConsumablesPanel
onready var consumables_label = $ConsumablesPanel/ConsumableLabel
onready var interaction_panel = $InteractionPanel
onready var interaction_panel_message = $InteractionPanel/HBoxContainer/Label
onready var interaction_panel_icon = $InteractionPanel/HBoxContainer/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_hp_bar()
	_update_money_panel()
	_update_consumables_panel()
	_update_interaction_panel()
	PlayerManager.connect("hp_changed", self, "_update_hp_bar")
	PlayerManager.connect("money_changed", self, "_update_money_panel")
	PlayerManager.connect("consumables_updated", self, "_update_consumables_panel")
	InteractionsManager.connect("interactions_updated", self, "_update_interaction_panel")
	
# Shows the crosshair.
func show_crosshair():
	crosshair.show()
	
# Hides the crosshair.
func hide_crosshair():
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
		consumables_panel.hide()
	else:
		var consumable := PlayerManager.get_current_consumable()
		consumables_label.text = consumable.consumable_name
		consumables_panel.show()

# Updates the interaction panel.
func _update_interaction_panel():
	if (InteractionsManager.interactions_empty()):
		interaction_panel.hide()
	else:
		var interaction = InteractionsManager.get_last_interaction()
		interaction_panel_icon.texture = interaction.interaction_icon
		interaction_panel_message.text = interaction.interaction_message
		interaction_panel.show()

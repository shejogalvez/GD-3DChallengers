extends Control

const TOTAL_HP_ADDS := [20, 50, 100]
const ATTACK_ADDS := [2, 3, 5]
const DEFENSE_ADDS := [1, 2, 4]

const TOTAL_HP_PRICES := [100, 300, 1000]
const ATTACK_PRICES := [200, 500, 1500]
const DEFENSE_PRICES := [200, 600, 1800]
const MAX_CONSUMABLE_PRICES := [2000, 4000]

onready var tooltip := $TooltipLayer/Tooltip
onready var tooltip_change_label := $TooltipLayer/Tooltip/ChangeLabel
onready var tooltip_cost_label := $TooltipLayer/Tooltip/RequirementsGrid/CostLabel

onready var memory_button_a := $TimeMachine/MemoryButtonA
onready var memory_popup_a := $MemoryPopupA
onready var memory_close_button_a := $MemoryPopupA/MemoryPanelA/MemoryCloseButtonA
onready var wallet_label_a := $MemoryPopupA/MemoryPanelA/WalletLabelA
onready var total_hp_button := $MemoryPopupA/MemoryPanelA/MemoryGridA/TotalHPRow/TotalHPControl/TotalHPButton
onready var total_hp_image := $MemoryPopupA/MemoryPanelA/MemoryGridA/TotalHPRow/TotalHPControl/TotalHPImage
onready var total_hp_button_2 := $MemoryPopupA/MemoryPanelA/MemoryGridA/TotalHPRow/TotalHPControl/TotalHPButton2
onready var total_hp_image_2 := $MemoryPopupA/MemoryPanelA/MemoryGridA/TotalHPRow/TotalHPControl/TotalHPImage2
onready var total_hp_button_3 := $MemoryPopupA/MemoryPanelA/MemoryGridA/TotalHPRow/TotalHPControl/TotalHPButton3
onready var total_hp_image_3 := $MemoryPopupA/MemoryPanelA/MemoryGridA/TotalHPRow/TotalHPControl/TotalHPImage3
onready var attack_button := $MemoryPopupA/MemoryPanelA/MemoryGridA/AttackRow/AttackControl/AttackButton
onready var attack_image := $MemoryPopupA/MemoryPanelA/MemoryGridA/AttackRow/AttackControl/AttackImage
onready var attack_button_2 := $MemoryPopupA/MemoryPanelA/MemoryGridA/AttackRow/AttackControl/AttackButton2
onready var attack_image_2 := $MemoryPopupA/MemoryPanelA/MemoryGridA/AttackRow/AttackControl/AttackImage2
onready var attack_button_3 := $MemoryPopupA/MemoryPanelA/MemoryGridA/AttackRow/AttackControl/AttackButton3
onready var attack_image_3 := $MemoryPopupA/MemoryPanelA/MemoryGridA/AttackRow/AttackControl/AttackImage3
onready var defense_button := $MemoryPopupA/MemoryPanelA/MemoryGridA/DefenseRow/DefenseControl/DefenseButton
onready var defense_image := $MemoryPopupA/MemoryPanelA/MemoryGridA/DefenseRow/DefenseControl/DefenseImage
onready var defense_button_2 := $MemoryPopupA/MemoryPanelA/MemoryGridA/DefenseRow/DefenseControl/DefenseButton2
onready var defense_image_2 := $MemoryPopupA/MemoryPanelA/MemoryGridA/DefenseRow/DefenseControl/DefenseImage2
onready var defense_button_3 := $MemoryPopupA/MemoryPanelA/MemoryGridA/DefenseRow/DefenseControl/DefenseButton3
onready var defense_image_3 := $MemoryPopupA/MemoryPanelA/MemoryGridA/DefenseRow/DefenseControl/DefenseImage3

onready var memory_button_b := $TimeMachine/MemoryButtonB
onready var memory_popup_b := $MemoryPopupB
onready var memory_close_button_b := $MemoryPopupB/MemoryPanelB/MemoryCloseButtonB
onready var wallet_label_b := $MemoryPopupB/MemoryPanelB/WalletLabelB
onready var max_consumable_button := $MemoryPopupB/MemoryPanelB/MemoryGridB/MaxConsumablesRow/MaxConsumablesControl/MaxConsumablesButton
onready var max_consumable_image := $MemoryPopupB/MemoryPanelB/MemoryGridB/MaxConsumablesRow/MaxConsumablesControl/MaxConsumablesImage
onready var max_consumable_button_2 := $MemoryPopupB/MemoryPanelB/MemoryGridB/MaxConsumablesRow/MaxConsumablesControl/MaxConsumablesButton2
onready var max_consumable_image_2 := $MemoryPopupB/MemoryPanelB/MemoryGridB/MaxConsumablesRow/MaxConsumablesControl/MaxConsumablesImage2

onready var close_button := $CloseButton
onready var audio_pointer := $AudioPointer
onready var audio_confirm := $AudioConfirm
onready var audio_reject := $AudioReject
onready var audio_popup := $AudioPopup
onready var audio_popdown := $AudioPopdown


# Called when the node enters the scene tree for the first time.
func _ready():
	# Initial connections.
	tooltip.visible = false
	total_hp_image.visible = false
	total_hp_image_2.visible = false
	total_hp_image_3.visible = false
	attack_image.visible = false
	attack_image_2.visible = false
	attack_image_3.visible = false
	defense_image.visible = false
	defense_image_2.visible = false
	defense_image_3.visible = false
	max_consumable_image.visible = false
	max_consumable_image_2.visible = false
	
	memory_button_a.connect("pressed", memory_popup_a, "popup")
	memory_button_b.connect("pressed", memory_popup_b, "popup")
	memory_button_a.connect("mouse_entered", audio_pointer, "play")
	memory_button_b.connect("mouse_entered", audio_pointer, "play")
	
	memory_popup_a.connect("about_to_show", audio_popup, 'play')
	memory_popup_b.connect("about_to_show", audio_popup, "play")
	memory_popup_a.connect("hide", self, "_hide_popup_safe")
	memory_popup_b.connect("hide", self, "_hide_popup_safe")

	memory_close_button_a.connect("pressed", memory_popup_a, "hide")
	memory_close_button_b.connect("pressed", memory_popup_b, "hide")
	memory_close_button_a.connect("mouse_entered", audio_pointer, "play")
	memory_close_button_b.connect("mouse_entered", audio_pointer, "play")
		
	close_button.connect("pressed", get_parent(), "hide")
	close_button.connect("mouse_entered", audio_pointer, "play")

	# Updating automatically based on Game Manager.
	_update_wallets()
	_update_memory_panels()
	GameManager.connect("money_changed", self, "_update_wallets")
	GameManager.connect("ingame_changed", self, "_update_memory_panels")
	
	# Adding funtionalities to alter Game Manager variables.
	total_hp_button.connect("pressed", self, "_try_add_total_hp", [0])
	total_hp_button_2.connect("pressed", self, "_try_add_total_hp", [1])
	total_hp_button_3.connect("pressed", self, "_try_add_total_hp", [2])
	attack_button.connect("pressed", self, "_try_add_attack", [0])
	attack_button_2.connect("pressed", self, "_try_add_attack", [1])
	attack_button_3.connect("pressed", self, "_try_add_attack", [2])
	defense_button.connect("pressed", self, "_try_add_defense", [0])
	defense_button_2.connect("pressed", self, "_try_add_defense", [1])
	defense_button_3.connect("pressed", self, "_try_add_defense", [2])
	max_consumable_button.connect("pressed", self, "_try_add_max_consumables", [0])
	max_consumable_button_2.connect("pressed", self, "_try_add_max_consumables", [1])

# Called on each input event.
func _input(event):
	if event.is_action_pressed("ui_cancel") and get_parent().visible:
		if memory_popup_a.visible:
			memory_popup_a.hide()
		elif memory_popup_b.visible:
			memory_popup_b.hide()
		else:
			get_parent().hide()
		get_tree().set_input_as_handled()

# Updates the wallets values.
func _update_wallets() -> void:
	wallet_label_a.text = "Wallet: $" + str(GameManager.get_money())
	wallet_label_b.text = "Wallet: $" + str(GameManager.get_money())
	
# Updates the memory panel.
func _update_memory_panels() -> void:
	_update_total_hp_panel()
	_update_attack_panel()
	_update_defense_panel()
	_update_max_consumables_panel()

# Updates the total health points panel.
func _update_total_hp_panel() -> void:
	match GameManager.get_total_hp():
		80:
			total_hp_button.disabled = false
			total_hp_button.connect("mouse_entered", self, "_show_tooltip", [{
				"change": "80 HP -> 100 HP",
				"cost" : TOTAL_HP_PRICES[0]
			}])
			total_hp_button.connect("mouse_exited", tooltip, "hide")
		100:
			total_hp_button.visible = false
			total_hp_image.visible = true
			total_hp_button_2.disabled = false
			total_hp_button_2.connect("mouse_entered", self, "_show_tooltip", [{
				"change": "100 HP -> 150 HP",
				"cost" : TOTAL_HP_PRICES[1]
			}])
			total_hp_button_2.connect("mouse_exited", tooltip, "hide")
		150:
			total_hp_button.visible = false
			total_hp_image.visible = true
			total_hp_button_2.visible = false
			total_hp_image_2.visible = true
			total_hp_button_3.disabled = false
			total_hp_button_3.connect("mouse_entered", self, "_show_tooltip", [{
				"change": "150 HP -> 250 HP",
				"cost" : TOTAL_HP_PRICES[2]
			}])
			total_hp_button_3.connect("mouse_exited", tooltip, "hide")
		250:
			total_hp_button.visible = false
			total_hp_image.visible = true
			total_hp_button_2.visible = false
			total_hp_image_2.visible = true
			total_hp_button_3.visible = false
			total_hp_image_3.visible = true
			
# Updates the attack panel.
func _update_attack_panel() -> void:
	match GameManager.get_attack():
		10:
			attack_button.disabled = false
			attack_button.connect("mouse_entered", self, "_show_tooltip", [{
				"change" : "10 ATK -> 12 ATK",
				"cost" : ATTACK_PRICES[0]
			}])
			attack_button.connect("mouse_exited", tooltip, "hide")
		12:
			attack_button.visible = false
			attack_image.visible = true
			attack_button_2.disabled = false
			attack_button_2.connect("mouse_entered", self, "_show_tooltip", [{
				"change" : "12 ATK -> 15 ATK",
				"cost" : ATTACK_PRICES[1]
			}])
			attack_button_2.connect("mouse_exited", tooltip, "hide")
		15:
			attack_button.visible = false
			attack_image.visible = true
			attack_button_2.visible = false
			attack_image_2.visible = true
			attack_button_3.disabled = false
			attack_button_3.connect("mouse_entered", self, "_show_tooltip", [{
				"change" : "15 ATK -> 20 ATK",
				"cost" : ATTACK_PRICES[2]
			}])
			attack_button_3.connect("mouse_exited", tooltip, "hide")
		20:
			attack_button.visible = false
			attack_image.visible = true
			attack_button_2.visible = false
			attack_image_2.visible = true
			attack_button_3.visible = false
			attack_image_3.visible = true
			
# Updates the defense panel.
func _update_defense_panel() -> void:
	match GameManager.get_defense():
		1:
			defense_button.disabled = false
			defense_button.connect("mouse_entered", self, "_show_tooltip", [{
				"change" : "1 DEF -> 2 DEF",
				"cost" : DEFENSE_PRICES[0]
			}])
			defense_button.connect("mouse_exited", tooltip, "hide")
		2:
			defense_button.visible = false
			defense_image.visible = true
			defense_button_2.disabled = false
			defense_button_2.connect("mouse_entered", self, "_show_tooltip", [{
				"change" : "2 DEF -> 4 DEF",
				"cost" : DEFENSE_PRICES[1]
			}])
			defense_button_2.connect("mouse_exited", tooltip, "hide")
		4:
			defense_button.visible = false
			defense_image.visible = true
			defense_button_2.visible = false
			defense_image_2.visible = true
			defense_button_3.disabled = false
			defense_button_3.connect("mouse_entered", self, "_show_tooltip", [{
				"change" : "4 DEF -> 8 DEF",
				"cost" : DEFENSE_PRICES[2]
			}])
			defense_button_3.connect("mouse_exited", tooltip, "hide")
		8:
			defense_button.visible = false
			defense_image.visible = true
			defense_button_2.visible = false
			defense_image_2.visible = true
			defense_button_3.visible = false
			defense_image_3.visible = true

# Updates the max. consumables panel.
func _update_max_consumables_panel() -> void:		
	match GameManager.get_max_consumables():
		1:
			max_consumable_button.disabled = false
			max_consumable_button.connect("mouse_entered", self, "_show_tooltip", [{
				"change" : "1 M.C. -> 2 M.C.",
				"cost" : MAX_CONSUMABLE_PRICES[0]
			}])
			max_consumable_button.connect("mouse_exited", tooltip, "hide")
		2:
			max_consumable_button.visible = false
			max_consumable_image.visible = true
			max_consumable_button_2.disabled = false
			max_consumable_button_2.connect("mouse_entered", self, "_show_tooltip", [{
				"change" : "2 M.C. -> 3 M.C.",
				"cost" : MAX_CONSUMABLE_PRICES[1]
			}])
			max_consumable_button_2.connect("mouse_exited", tooltip, "hide")
		3: 
			max_consumable_button.visible = false
			max_consumable_image.visible = true
			max_consumable_button_2.visible = false
			max_consumable_image_2.visible = true
			
# Tries to add total health points.
func _try_add_total_hp(index: int) -> void:
	if GameManager.get_money() >= TOTAL_HP_PRICES[index]:
		GameManager.remove_money(TOTAL_HP_PRICES[index])
		GameManager.add_total_hp(TOTAL_HP_ADDS[index])
		tooltip.hide()
		audio_confirm.play()
	else:
		audio_reject.play()

# Tries to add attack.
func _try_add_attack(index : int) -> void:
	if GameManager.get_money() >= ATTACK_PRICES[index]:
		GameManager.remove_money(ATTACK_PRICES[index])
		GameManager.add_attack(ATTACK_ADDS[index])
		tooltip.hide()
		audio_confirm.play()
	else:
		audio_reject.play()

# Tries to add defense.
func _try_add_defense(index : int) -> void:
	if GameManager.get_money() >= DEFENSE_PRICES[index]:
		GameManager.remove_money(DEFENSE_PRICES[index])
		GameManager.add_defense(DEFENSE_ADDS[index])
		tooltip.hide()
		audio_confirm.play()
	else:
		audio_reject.play()

# Tries to add max. consumables.
func _try_add_max_consumables(index : int) -> void:
	if GameManager.get_money() >= MAX_CONSUMABLE_PRICES[index]:
		GameManager.remove_money(MAX_CONSUMABLE_PRICES[index])
		GameManager.add_max_consumables()
		tooltip.hide()
		audio_confirm.play()
	else:
		audio_reject.play()
	
# Hides a popup safely.
func _hide_popup_safe() -> void:
	tooltip.hide()
	audio_popdown.play()
	
# Shows the tooltip with the given information.
func _show_tooltip(info : Dictionary) -> void:
	tooltip_change_label.text = info["change"]
	tooltip_cost_label.text = "Cost: $" + str(info["cost"])
	tooltip.rect_position = get_viewport().get_mouse_position() + Vector2(20, 20)
	tooltip.show()
	audio_pointer.play()

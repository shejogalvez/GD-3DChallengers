extends Control

const MAX_CONSUMABLE_PRICES := [100, 300, 800]

onready var memory_button_a := $TimeMachine/MemoryButtonA
onready var memory_popup_a := $MemoryPopupA
onready var memory_close_button_a := $MemoryPopupA/MemoryPanelA/MemoryCloseButtonA
onready var total_hp_button := $MemoryPopupA/MemoryPanelA/MemoryGridA/TotalHPRow/TotalHPControl/TotalHPButton
onready var total_hp_button_2 := $MemoryPopupA/MemoryPanelA/MemoryGridA/TotalHPRow/TotalHPControl/TotalHPButton2
onready var total_hp_button_3 := $MemoryPopupA/MemoryPanelA/MemoryGridA/TotalHPRow/TotalHPControl/TotalHPButton3
onready var attack_button := $MemoryPopupA/MemoryPanelA/MemoryGridA/AttackRow/AttackControl/AttackButton
onready var attack_button_2 := $MemoryPopupA/MemoryPanelA/MemoryGridA/AttackRow/AttackControl/AttackButton2
onready var attack_button_3 := $MemoryPopupA/MemoryPanelA/MemoryGridA/AttackRow/AttackControl/AttackButton3
onready var defense_button := $MemoryPopupA/MemoryPanelA/MemoryGridA/DefenseRow/DefenseControl/DefenseButton
onready var defense_button_2 := $MemoryPopupA/MemoryPanelA/MemoryGridA/DefenseRow/DefenseControl/DefenseButton2
onready var defense_button_3 := $MemoryPopupA/MemoryPanelA/MemoryGridA/DefenseRow/DefenseControl/DefenseButton3

onready var memory_button_b := $TimeMachine/MemoryButtonB
onready var memory_popup_b := $MemoryPopupB
onready var memory_close_button_b := $MemoryPopupB/MemoryPanelB/MemoryCloseButtonB
onready var max_consumable_button := $MemoryPopupB/MemoryPanelB/MemoryGridB/MaxConsumablesRow/MaxConsumablesControl/MaxConsumablesButton
onready var max_consumable_image := $MemoryPopupB/MemoryPanelB/MemoryGridB/MaxConsumablesRow/MaxConsumablesControl/MaxConsumablesImage
onready var max_consumable_button_2 := $MemoryPopupB/MemoryPanelB/MemoryGridB/MaxConsumablesRow/MaxConsumablesControl/MaxConsumablesButton2
onready var max_consumable_image_2 := $MemoryPopupB/MemoryPanelB/MemoryGridB/MaxConsumablesRow/MaxConsumablesControl/MaxConsumablesImage2
onready var max_consumable_button_3 := $MemoryPopupB/MemoryPanelB/MemoryGridB/MaxConsumablesRow/MaxConsumablesControl/MaxConsumablesButton3
onready var max_consumable_image_3 := $MemoryPopupB/MemoryPanelB/MemoryGridB/MaxConsumablesRow/MaxConsumablesControl/MaxConsumablesImage3

onready var close_button := $CloseButton
onready var audio_pointer := $AudioPointer
onready var audio_confirm := $AudioConfirm
onready var audio_reject := $AudioReject
onready var audio_popup := $AudioPopup
onready var audio_popdown := $AudioPopdown


# Called when the node enters the scene tree for the first time.
func _ready():
	# Initial connections.
	
	max_consumable_image.visible = false
	max_consumable_image_2.visible = false
	max_consumable_image_3.visible = false
	
	memory_button_a.connect("pressed", memory_popup_a, "popup")
	memory_button_b.connect("pressed", memory_popup_b, "popup")
	memory_button_a.connect("mouse_entered", audio_pointer, "play")
	memory_button_b.connect("mouse_entered", audio_pointer, "play")
	
	memory_popup_a.connect("about_to_show", audio_popup, 'play')
	memory_popup_b.connect("about_to_show", audio_popup, "play")
	memory_popup_a.connect("hide", audio_popdown, "play")
	memory_popup_b.connect("hide", audio_popdown, "play")

	memory_close_button_a.connect("pressed", memory_popup_a, "hide")
	memory_close_button_b.connect("pressed", memory_popup_b, "hide")
	memory_close_button_a.connect("mouse_entered", audio_pointer, "play")
	memory_close_button_b.connect("mouse_entered", audio_pointer, "play")
		
	close_button.connect("pressed", get_parent(), "hide")
	close_button.connect("mouse_entered", audio_pointer, "play")

	# Updating automatically based on Game Manager.

	_update_memory_panels()
	GameManager.connect("ingame_changed", self, "_update_memory_panels")
	
	# Adding funtionalities to alter Game Manager variables.
	
	max_consumable_button.connect("pressed", self, "_try_add_max_consumables", [0])
	max_consumable_button_2.connect("pressed", self, "_try_add_max_consumables", [1])
	max_consumable_button_3.connect("pressed", self, "_try_add_max_consumables", [2])
	
# Updates the memory panel.
func _update_memory_panels() -> void:
	match GameManager.get_max_consumables():
		1:
			max_consumable_button.disabled = false
			max_consumable_button.connect("mouse_entered", audio_pointer, "play")
		2:
			max_consumable_button.visible = false
			max_consumable_image.visible = true
			max_consumable_button_2.disabled = false
			max_consumable_button_2.connect("mouse_entered", audio_pointer, "play")
		3: 
			max_consumable_button.visible = false
			max_consumable_image.visible = true
			max_consumable_button_2.visible = false
			max_consumable_image_2.visible = true
			max_consumable_button_3.disabled = false
			max_consumable_button_3.connect("mouse_entered", audio_pointer, "play")
		4:
			max_consumable_button.visible = false
			max_consumable_image.visible = true
			max_consumable_button_2.visible = false
			max_consumable_image_2.visible = true
			max_consumable_button_3.visible = false
			max_consumable_image_3.visible = true

# Tries to add max consumables.
func _try_add_max_consumables(index : int) -> void:
	if GameManager.get_money() >= MAX_CONSUMABLE_PRICES[index]:
		GameManager.remove_money(MAX_CONSUMABLE_PRICES[index])
		GameManager.add_max_consumables()
		audio_confirm.play()
	else:
		audio_reject.play()
	

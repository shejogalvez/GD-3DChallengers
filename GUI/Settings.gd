extends Panel

var display_buttongroup := ButtonGroup.new()
var gui_size_buttongroup := ButtonGroup.new()

var display_buttonlist := []
var gui_size_buttonlist := []

onready var fullscreen_button := $TabContainer/Graphics/GraphicsGrid/DisplayRow/DisplayButtonsControl/FullscreenButton
onready var windows_button := $TabContainer/Graphics/GraphicsGrid/DisplayRow/DisplayButtonsControl/WindowButton

onready var resolution_dropdown := $TabContainer/Graphics/GraphicsGrid/ResolutionRow/ResolutionDropdownControl/ResolutionDropdown

onready var small_gui_button := $TabContainer/Graphics/GraphicsGrid/GUISizeRow/GUISizeButtonsControl/SmallGUIButton
onready var medium_gui_button := $TabContainer/Graphics/GraphicsGrid/GUISizeRow/GUISizeButtonsControl/MediumGUIButton
onready var big_gui_button := $TabContainer/Graphics/GraphicsGrid/GUISizeRow/GUISizeButtonsControl/BigGUIButton

onready var back_button := $BackButton


# Called when the node enters the scene tree for the first time.
func _ready():
	# Grouping.
	fullscreen_button.group = display_buttongroup
	windows_button.group = display_buttongroup
	
	small_gui_button.group = gui_size_buttongroup
	medium_gui_button.group = gui_size_buttongroup
	big_gui_button.group = gui_size_buttongroup
	
	display_buttonlist = [fullscreen_button, windows_button]
	gui_size_buttonlist = [small_gui_button, medium_gui_button, big_gui_button]
	
		# Deleting the radio button from dropdown.
	var items_menu : PopupMenu = resolution_dropdown.get_popup()
	for index in items_menu.get_item_count():
		if items_menu.is_item_radio_checkable(index):
			items_menu.set_item_as_radio_checkable(index, false)
			
	display_buttongroup.connect("pressed", self, "_change_display_mode")
	resolution_dropdown.connect("item_selected", self, "_change_resolution")
	gui_size_buttongroup.connect("pressed", self, "_change_gui_size")
	back_button.connect("pressed", self, "hide")
	
	# Updating from game data.
	display_buttonlist[GameManager.game_data["settings"]["display_mode"]].set_pressed_no_signal(true)
	resolution_dropdown.select(GameManager.game_data["settings"]["resolution"])
	gui_size_buttonlist[GameManager.game_data["settings"]["gui_size"]].pressed = true
	


# Called on each input event.
func _input(event):
	if self.visible and event.is_action_pressed("ui_cancel"):
		hide()
		get_tree().set_input_as_handled()

# Changes the display mode.
func _change_display_mode(_button : Object) -> void:
	GameManager.game_data["settings"]["display_mode"] = display_buttonlist.find(display_buttongroup.get_pressed_button())
	GameManager.update_display_mode()
	GameManager.save_data()
	
# Changes the resolution of the screen.
func _change_resolution(resolution_index : int) -> void:
	GameManager.game_data["settings"]["resolution"] = resolution_index
	GameManager.update_resolution()
	GameManager.save_data()
	
# Changes the resizable GUI scale.
func _change_gui_size(_button : Object) -> void:
	GameManager.game_data["settings"]["gui_size"] = gui_size_buttonlist.find(gui_size_buttongroup.get_pressed_button())
	GameManager.update_gui_size()
	GameManager.save_data()

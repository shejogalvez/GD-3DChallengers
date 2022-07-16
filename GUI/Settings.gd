extends Panel

var display_buttongroup := ButtonGroup.new()
var gui_size_buttongroup := ButtonGroup.new()

var display_buttonlist := []
var gui_size_buttonlist := []

var in_key_selection = false

onready var fullscreen_button := $TabContainer/Graphics/GraphicsGrid/DisplayRow/DisplayButtonsControl/FullscreenButton
onready var windows_button := $TabContainer/Graphics/GraphicsGrid/DisplayRow/DisplayButtonsControl/WindowButton

onready var resolution_dropdown := $TabContainer/Graphics/GraphicsGrid/ResolutionRow/ResolutionDropdownControl/ResolutionDropdown

onready var small_gui_button := $TabContainer/Graphics/GraphicsGrid/GUISizeRow/GUISizeButtonsControl/SmallGUIButton
onready var medium_gui_button := $TabContainer/Graphics/GraphicsGrid/GUISizeRow/GUISizeButtonsControl/MediumGUIButton
onready var big_gui_button := $TabContainer/Graphics/GraphicsGrid/GUISizeRow/GUISizeButtonsControl/BigGUIButton

onready var show_fps_checkbox := $TabContainer/Graphics/GraphicsGrid/ShowFPSRow/ShowFPSControl/ShowFPSCheckBox

onready var global_volume_slider := $TabContainer/Sound/SoundGrid/GlobalVolumeRow/GlobalVolumeControl/GlobalVolumeSlider
onready var music_volume_slider := $TabContainer/Sound/SoundGrid/MusicVolumeRow/MusicVolumeControl/MusicVolumeSlider
onready var sfx_volume_slider := $TabContainer/Sound/SoundGrid/SFXVolumeRow/SFXVolumeControl/SFXVolumeSlider

onready var key_input_popup := $KeyInputPopup
onready var key_input_label := $KeyInputPopup/KeyInputPanel/KeyInputLabel
onready var consumable_button := $TabContainer/Controls/ControlsGrid/ConsumableRow/ConsumableControl/ConsumableButton

onready var back_button := $BackButton
onready var default_button := $DefaultButton

# Called when the node enters the scene tree for the first time.
func _ready():
	# ================
	# GRAPHICS
	# ================
	
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
	show_fps_checkbox.connect("pressed", self, "_change_fps_display")
	
	# Updating from game data.
	display_buttonlist[GameManager.game_data["settings"]["display_mode"]].set_pressed_no_signal(true)
	resolution_dropdown.select(GameManager.game_data["settings"]["resolution"])
	gui_size_buttonlist[GameManager.game_data["settings"]["gui_size"]].pressed = true
	show_fps_checkbox.pressed = GameManager.game_data["settings"]["show_fps"]
	_change_fps_display()
	
	# ================
	# SOUND
	# ================
	
	global_volume_slider.connect("value_changed", self, "_change_global_volume")
	music_volume_slider.connect("value_changed", self, "_change_music_volume")
	sfx_volume_slider.connect("value_changed", self, "_change_sfx_volume")

	# Updating from game data.
	global_volume_slider.value = GameManager.game_data["settings"]["global_volume"]
	music_volume_slider.value = GameManager.game_data["settings"]["music_volume"]
	sfx_volume_slider.value = GameManager.game_data["settings"]["sfx_volume"]
		
	# ================
	# CONTROLS (loose implementation for learning purposes, changes are not saved)
	# ================
	
	consumable_button.text = InputMap.get_action_list("use_consumable")[0].as_text()
	
	consumable_button.connect("pressed", self, "_show_key_input")
	
	back_button.connect("pressed", self, "_close")
	back_button.connect("mouse_entered", AudioStreamManager, "play_button_hover")
	default_button.connect("pressed", self, "_set_default")
	default_button.connect("mouse_entered", AudioStreamManager, "play_button_hover")

# Called on each input event.
func _input(event):
	if event is InputEventKey and in_key_selection:
		get_tree().set_input_as_handled()
		
		# Check if new key was assigned somewhere
		for action in InputMap.get_actions():
			if InputMap.action_has_event(action, event):
				key_input_label.text = "Key " + event.as_text() + " already used!"
				return
				
		# Add new key
		if !InputMap.get_action_list("use_consumable").empty():
			InputMap.action_erase_event("use_consumable", InputMap.get_action_list("use_consumable")[0])
		
		InputMap.action_add_event("use_consumable", event)
		key_input_popup.hide()
		in_key_selection = false
		consumable_button.text = InputMap.get_action_list("use_consumable")[0].as_text()
		key_input_label.text = "Press a valid key"
	
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

# Changes the FPS displayers.
func _change_fps_display() -> void:
	GameManager.game_data["settings"]["show_fps"] = show_fps_checkbox.pressed
	GameManager.update_fps_display()
	GameManager.save_data()

# Changes the global volume.	
func _change_global_volume(value : float) -> void:
	GameManager.game_data["settings"]["global_volume"] = value
	GameManager.update_global_volume()
	GameManager.save_data()

# Changes the music volume.
func _change_music_volume(value : float) -> void:
	GameManager.game_data["settings"]["music_volume"] = value
	GameManager.update_music_volume()
	GameManager.save_data()

# Changes the sound effects volume.
func _change_sfx_volume(value : float) -> void:
	GameManager.game_data["settings"]["sfx_volume"] = value
	GameManager.update_sfx_volume()
	GameManager.save_data()

# Sets the default settings.
func _set_default() -> void:
	GameManager.set_default_settings()
	GameManager.update_graphics_settings()
	GameManager.update_volume_settings()
	GameManager.save_data()
	
	# Updating from game data.
	display_buttonlist[GameManager.game_data["settings"]["display_mode"]].set_pressed_no_signal(true)
	resolution_dropdown.select(GameManager.game_data["settings"]["resolution"])
	gui_size_buttonlist[GameManager.game_data["settings"]["gui_size"]].pressed = true
	show_fps_checkbox.pressed = GameManager.game_data["settings"]["show_fps"]
	
	# Updating from game data.
	global_volume_slider.value = GameManager.game_data["settings"]["global_volume"]
	music_volume_slider.value = GameManager.game_data["settings"]["music_volume"]
	sfx_volume_slider.value = GameManager.game_data["settings"]["sfx_volume"]
	
	AudioStreamManager.play_button_pressed()

# Shows the key input popup.
func _show_key_input() -> void:
	key_input_popup.popup()
	in_key_selection = true
	
# Closes the window.
func _close() -> void:
	hide()
	AudioStreamManager.play_button_pressed()

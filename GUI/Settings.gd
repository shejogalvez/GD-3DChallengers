extends Panel

var display_buttongroup := ButtonGroup.new()
var gui_size_buttongroup := ButtonGroup.new()

onready var fullscreen_button := $TabContainer/Graphics/GraphicsGrid/DisplayRow/DisplayButtonsControl/FullscreenButton
onready var windows_button := $TabContainer/Graphics/GraphicsGrid/DisplayRow/DisplayButtonsControl/WindowButton

onready var resolution_dropdown := $TabContainer/Graphics/GraphicsGrid/ResolutionRow/ResolutionDropdownControl/ResolutionDropdown

onready var small_gui_button := $TabContainer/Graphics/GraphicsGrid/GUISizeRow/GUISizeButtonsControl/SmallGUIButton
onready var medium_gui_button := $TabContainer/Graphics/GraphicsGrid/GUISizeRow/GUISizeButtonsControl/MediumGUIButton
onready var big_gui_button := $TabContainer/Graphics/GraphicsGrid/GUISizeRow/GUISizeButtonsControl/BigGUIButton

onready var back_button := $BackButton


# Called when the node enters the scene tree for the first time.
func _ready():
	fullscreen_button.group = display_buttongroup
	windows_button.group = display_buttongroup
	
	small_gui_button.group = gui_size_buttongroup
	medium_gui_button.group = gui_size_buttongroup
	big_gui_button.group = gui_size_buttongroup
	
	var items_menu : PopupMenu = resolution_dropdown.get_popup()
	for index in items_menu.get_item_count():
		if items_menu.is_item_radio_checkable(index):
			items_menu.set_item_as_radio_checkable(index, false)
			
	display_buttongroup.connect("pressed", self, "_change_display_mode")
	resolution_dropdown.connect("item_selected", self, "_change_resolution")
	gui_size_buttongroup.connect("pressed", self, "_change_gui_size")
	back_button.connect("pressed", self, "hide")

# Called on each input event.
func _input(event):
	if self.visible and event.is_action_pressed("ui_cancel"):
		hide()
		get_tree().set_input_as_handled()

# Changes the display mode.
func _change_display_mode(_button : Object) -> void:
	if fullscreen_button.pressed: 
		OS.window_fullscreen = true
	elif windows_button.pressed:
		OS.window_fullscreen = false

# Changes the resolution of the screen.
func _change_resolution(index : int) -> void:
	OS.set_window_maximized(false)
	match index:
		0 : OS.set_window_size(Vector2(1920, 1080))
		1 : OS.set_window_size(Vector2(1600, 900))
		2 : OS.set_window_size(Vector2(1280, 720))
		3 : OS.set_window_size(Vector2(1024, 600))
		
# Changes the resizable GUI scale.
func _change_gui_size(_button : Object) -> void:
	var gui_scale : Vector2
	if small_gui_button.pressed:
		gui_scale = Vector2(0.8, 0.8)
	elif medium_gui_button.pressed:
		gui_scale = Vector2(1.0, 1.0)
	elif big_gui_button.pressed:
		gui_scale = Vector2(1.2, 1.2)
		
	for node in get_tree().get_nodes_in_group("resizable_gui"):
		node.rect_scale = gui_scale


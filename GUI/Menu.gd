extends CanvasLayer

export(String, FILE) var main_menu_scene_path

var previous_mouse_mode

onready var menu_control := $MenuControl
onready var buttons_container := $MenuControl/MenuPanel/ButtonsContainer
onready var resume_button := $MenuControl/MenuPanel/ButtonsContainer/ResumeButton
onready var settings_button := $MenuControl/MenuPanel/ButtonsContainer/SettingsButton
onready var credits_button := $MenuControl/MenuPanel/ButtonsContainer/CreditsButton
onready var main_menu_button := $MenuControl/MenuPanel/ButtonsContainer/MainMenuButton
onready var settings := $MenuControl/Settings
onready var credits := $MenuControl/Credits
onready var animation_player := $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	menu_control.hide()
	settings.hide()
	credits.hide()
	for button in buttons_container.get_children():
		button.connect("mouse_entered", AudioStreamManager, "play_button_hover")
	resume_button.connect("pressed", self, "_resume_game")
	settings_button.connect("pressed", self, "_show_settings")
	credits_button.connect("pressed", self, "_show_credits")
	main_menu_button.connect("pressed", self, "_go_to_main_menu")

# Called on each input event.
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if not menu_control.visible:
			_pause_game()
		else:
			_resume_game()
		get_tree().set_input_as_handled()
		
# Pauses the game.
func _pause_game() -> void:
	previous_mouse_mode = Input.get_mouse_mode()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	menu_control.show()
	get_tree().paused = true
	animation_player.play("menu_appear")
	AudioStreamManager.play_button_hover()

# Resumes the game.
func _resume_game() -> void:
	Input.set_mouse_mode(previous_mouse_mode) 
	menu_control.hide()
	get_tree().paused = false
	animation_player.play("RESET")
	AudioStreamManager.play_button_pressed()

# Shows the settings.
func _show_settings() -> void:
	settings.show()
	AudioStreamManager.play_button_pressed()

# Shows the credits.
func _show_credits() -> void:
	credits.show()
	AudioStreamManager.play_button_pressed()
	
# Changes the scene to the main menu.
func _go_to_main_menu() -> void:
	get_tree().paused = false
	SceneChangesManager.change_scene_chunked(main_menu_scene_path)
	AudioStreamManager.play_button_pressed()
	
	

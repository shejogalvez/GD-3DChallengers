extends CanvasLayer

var previous_mouse_mode

onready var menu_control := $MenuControl
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
	resume_button.connect("pressed", self, "_resume_game")
	settings_button.connect("pressed", self, "_show_settings")
	credits_button.connect("pressed", self, "_show_credits")

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
	animation_player.play("menu_appear")
	get_tree().paused = true

# Resumes the game.
func _resume_game() -> void:
	Input.set_mouse_mode(previous_mouse_mode) 
	menu_control.hide()
	animation_player.play("RESET")
	get_tree().paused = false

# Shows the settings.
func _show_settings() -> void:
	settings.show()

# Shows the credits.
func _show_credits() -> void:
	credits.show()

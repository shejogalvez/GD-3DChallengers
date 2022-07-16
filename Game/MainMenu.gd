extends Control

export(String, FILE) var main_hub_scene_path = "res://Game/MainHub.tscn"

onready var fps_label := $FPSLabel
onready var menu := $Menu
onready var new_game_button := $Menu/NewGameButton
onready var continue_button := $Menu/ContinueButton
onready var settings_button := $Menu/SettingsButton
onready var credits_button := $Menu/CreditsButton
onready var exit_button := $Menu/ExitButton
onready var settings := $Settings
onready var credits := $Credits

# Called when the node enters the scene tree for the first time.
func _ready():
	settings.hide()
	credits.hide()
	for button in menu.get_children():
		button.connect("mouse_entered", AudioStreamManager, "play_button_hover")
	new_game_button.connect("pressed", self, "_start_new_game")
	continue_button.connect("pressed", self, "_continue_game")
	settings_button.connect("pressed", self, "_show_settings")
	credits_button.connect("pressed", self, "_show_credits")
	exit_button.connect("pressed", self, "_exit_game")

# Called every frame.
func _process(delta):
	fps_label.text = str(Engine.get_frames_per_second()) + " FPS"

# Called on each input event.
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		exit_button.emit_signal("pressed")

# Starts a new game.
func _start_new_game() -> void:
	get_tree().change_scene(main_hub_scene_path)
	AudioStreamManager.play_button_pressed()

# Continues the game.
func _continue_game() -> void:
	get_tree().change_scene(main_hub_scene_path)
	AudioStreamManager.play_button_pressed()

# Shows the settings.
func _show_settings() -> void:
	AudioStreamManager.play_button_pressed()
	settings.show()

# Shows the credits.
func _show_credits() -> void:
	AudioStreamManager.play_button_pressed()
	credits.show()
	
# Exits the game
func _exit_game() -> void:
	AudioStreamManager.play_button_pressed()
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

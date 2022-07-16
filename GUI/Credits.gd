extends Panel

onready var back_button := $BackButton


# Called when the node enters the scene tree for the first time.
func _ready():
	back_button.connect("pressed", self, "_close")
	back_button.connect("mouse_entered", AudioStreamManager, "play_button_hover")

# Called on each input event.
func _input(event):
	if self.visible and event.is_action_pressed("ui_cancel"):
		hide()
		get_tree().set_input_as_handled()

# Closes the window.
func _close() -> void:
	hide()
	AudioStreamManager.play_button_pressed()

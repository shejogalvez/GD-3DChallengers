extends Control

onready var close_button := $CloseButton
onready var audio_pointer := $AudioPointer
onready var audio_confirm := $AudioConfirm

# Called when the node enters the scene tree for the first time.
func _ready():
	close_button.connect("pressed", get_parent(), "hide")
	close_button.connect("mouse_entered", audio_pointer, "play")

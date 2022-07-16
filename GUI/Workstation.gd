extends Control

onready var memory_button := $TimeMachine/MemoryButton
onready var memory_popup := $MemoryPopup
onready var memory_close_button := $MemoryPopup/MemoryPanel/MemoryCloseButton
onready var close_button := $CloseButton
onready var audio_pointer := $AudioPointer
onready var audio_confirm := $AudioConfirm
onready var audio_popup := $AudioPopup
onready var audio_popdown := $AudioPopdown

# Called when the node enters the scene tree for the first time.
func _ready():
	memory_button.connect("pressed", memory_popup, "popup")
	memory_button.connect("mouse_entered", audio_pointer, "play")
	
	memory_popup.connect("about_to_show", audio_popup, "play")
	memory_popup.connect("hide", audio_popdown, "play")

	memory_close_button.connect("pressed", memory_popup, "hide")
	memory_close_button.connect("mouse_entered", audio_pointer, "play")
		
	close_button.connect("pressed", get_parent(), "hide")
	close_button.connect("mouse_entered", audio_pointer, "play")

	

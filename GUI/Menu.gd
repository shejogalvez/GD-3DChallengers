extends Control

var previous_mouse_mode

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called each frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if not visible:
			previous_mouse_mode = Input.get_mouse_mode()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			show()
			get_tree().paused = true
		else:
			Input.set_mouse_mode(previous_mouse_mode) 
			hide()
			get_tree().paused = false

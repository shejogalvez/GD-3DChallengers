extends CanvasLayer

var previous_mouse_mode

onready var menu_control = $MenuControl
onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	menu_control.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if not menu_control.visible:
			previous_mouse_mode = Input.get_mouse_mode()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			menu_control.show()
			animation_player.play("menu_appear")
			get_tree().paused = true
		else:
			Input.set_mouse_mode(previous_mouse_mode) 
			menu_control.hide()
			animation_player.play("RESET")
			get_tree().paused = false

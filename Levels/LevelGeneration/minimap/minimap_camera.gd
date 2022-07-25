extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if PlayerManager.is_head_view():
		rotation = -PlayerManager.get_player().rotation.y + PI
	else:
		var camera_rot = PlayerManager.get_player().topdown_camera.get_global_transform().basis.get_euler()
		rotation = -camera_rot.y

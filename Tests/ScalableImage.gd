extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const WIDTH = 128
const HEIGHT = 128

# Called when the node enters the scene tree for the first time.
func _ready():
	var width_factor = 5*WIDTH / $Viewport/Sprite.texture.get_width()
	var height_factor = 5*HEIGHT / $Viewport/Sprite.texture.get_height()
	mesh.set_size(Vector2(width_factor, height_factor))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

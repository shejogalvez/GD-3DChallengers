extends Node

var loader
var wait_frames
var time_max := 100 # msec
var current_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

# Goes to the given scene.
func goto_scene(path): # Game requests to switch to this scene.
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # Check for errors.
		#show_error()
		return
	set_process(true)

	current_scene.queue_free() # Get rid of the old scene.

	# Start your "loading..." animation.
	get_node("animation").play("loading")

	wait_frames = 1

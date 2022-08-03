extends Node

const loading_screen := preload("res://Addons/SceneChanges/LoadingScreen.tscn")
const MAX_LOAD_TIME := 50 # in milliseconds

var loader : ResourceInteractiveLoader
var waiting_loading_screen := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:

	if loader == null:
		# No need to process anymore.
		set_process(false)
		return
		
	if waiting_loading_screen:
		waiting_loading_screen = false
		return
		
	var init_time = OS.get_ticks_msec()
	# Use "MAX_LOAD_TIME" to control for how long we block this thread.
	while OS.get_ticks_msec() - init_time < MAX_LOAD_TIME:
		# Poll your loader.
		var err = loader.poll()

		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
		elif err == OK:
			update_progress()
		else: # Error during loading.
			loader = null
			break
	
# Changes the scene the normal way, given a path.
func change_scene(path : String) -> void:
	get_tree().change_scene(path)
	
# Changes the scene the normal way, given a scene.
func change_scene_to(packed_scene : PackedScene) -> void:
	get_tree().change_scene_to(packed_scene)
	
# Changes the scene, but in chunks, given a path.
func change_scene_chunked(path : String) -> void: # Game requests to switch to this scene.
	loader = ResourceLoader.load_interactive(path)
	
	if loader == null: # Check for errors.
		return
		
	set_process(true)
	waiting_loading_screen = true

	var loading_screen_scene = loading_screen.instance()
	get_tree().current_scene.queue_free() # Get rid of the old scene.
	get_tree().root.add_child(loading_screen_scene)
	get_tree().current_scene = loading_screen_scene


# Updates the progress.
func update_progress() -> void:
	var progress_percentage = 100.0 * float(loader.get_stage()) / loader.get_stage_count()
	get_tree().current_scene.update_progress(progress_percentage)

# Sets the new current scene.
func set_new_scene(scene_resource : PackedScene) -> void:
	var scene = scene_resource.instance()
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(scene)
	get_tree().current_scene = scene



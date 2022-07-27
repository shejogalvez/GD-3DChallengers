extends Node

# Goes to the given scene.
func goto_scene(path : String) -> void:
	var loader = ResourceLoader.load_interactive(path)
	
	while true:
		var error = loader.poll()
		
		var loading_screen = load("res://Addons/SceneChanger/LoadingScreen.tscn")
		
		get_tree().get_root().call_deferred("add_child", loading_screen)
		
		if error == ERR_FILE_EOF:
			# Loading has been completed
			var resource : PackedScene = loader.get_resource()
			get_tree().get_root().call_deferred("add_child", resource.instance())
			break
		if error == OK:
			# Still loading
			var progress = loader.get_stage() / loader.get_stage_count()
		yield(get_tree(), "idle_frame")

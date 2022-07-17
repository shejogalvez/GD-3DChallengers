extends Node

const DISPLAY_MODES := [
	true,
	false
]

const RESOLUTIONS := [
	Vector2(1920, 1080),
	Vector2(1600, 900),
	Vector2(1280, 720),
	Vector2(1024, 600)
]

const GUI_SIZES = [
	Vector2(1.0, 1.0),
	Vector2(1.2, 1.2),
	Vector2(1.4, 1.4)
]
const GAME_DATA_PATH := "user://save_file.save"

var new_game := {
	"day": 1,
	"money": 10,
	"max_consumables" : 1
}

var default_settings := {
	"display_mode" : 1,
	"resolution" : 3,
	"gui_size" : 1,
	"show_fps": false,
	"global_volume" : 0.0,
	"music_volume" : 0.0,
	"sfx_volume" : 0.0	
}

var game_data := {
	"meta" : {
		"saved" : false,
	},
	"game" : new_game.duplicate(),
	"settings" : default_settings.duplicate()
}

# Called when the node enters the scene tree for the first time.
func _ready():
	load_data()
	update_graphics_settings()
	update_volume_settings()

# Called on a certain notification.
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_data()
		get_tree().quit()
		
# Saves the game data.
func save_data() -> void:
	var saveFile := File.new()
	saveFile.open(GAME_DATA_PATH, File.WRITE)
	saveFile.store_line(to_json(game_data))
	saveFile.close()
	
# Loads the game data.
func load_data() -> void:
	var openFile := File.new()
	
	if not openFile.file_exists(GAME_DATA_PATH):
		return
	
	openFile.open(GAME_DATA_PATH, File.READ)
	
	# while not necessary 
	while openFile.get_position() < openFile.get_len():
		var possible_game_data = parse_json(openFile.get_line())
		if typeof(possible_game_data) == TYPE_DICTIONARY:
			transfer_dictionary_data(game_data, possible_game_data)

	openFile.close()
	
# Transfers data from one dictionary to the other.
func transfer_dictionary_data(receiver : Dictionary, sender : Dictionary) -> void:
	for key in receiver:
		if key in sender and typeof(receiver[key]) != TYPE_DICTIONARY:
			receiver[key] = sender[key]
		elif key in sender and typeof(receiver[key]) == TYPE_DICTIONARY and typeof(sender[key]) == TYPE_DICTIONARY:
			transfer_dictionary_data(receiver[key], sender[key])
				

# Sets a new game.
func set_new_game() -> void:
	game_data["meta"]["saved"] = true
	game_data["game"] = new_game.duplicate()

# Updates the window display mode.
func update_display_mode() -> void:
	OS.window_fullscreen = DISPLAY_MODES[game_data["settings"]["display_mode"]]

# Updates the window resolution.
func update_resolution() -> void:
	OS.window_size = RESOLUTIONS[game_data["settings"]["resolution"]]
	OS.window_position = (OS.get_screen_size() - OS.window_size) * 0.5

# Updates the GUI size.
func update_gui_size() -> void:
	for node in get_tree().get_nodes_in_group("resizable_gui"):
		node.rect_scale = GUI_SIZES[game_data["settings"]["gui_size"]]

# Updates the FPS displayers.
func update_fps_display() -> void:
	for node in get_tree().get_nodes_in_group("fps_displayer"):
		node.visible = game_data["settings"]["show_fps"]

# Updates every graphic setting.
func update_graphics_settings() -> void:
	update_display_mode()
	update_resolution()
	update_gui_size()
	update_fps_display()

# Updates the global volume.
func update_global_volume() -> void:
	if game_data["settings"]["global_volume"] <= -25.0:
		game_data["settings"]["global_volume"] = -80.0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), game_data["settings"]["global_volume"])

# Updates the music volume.
func update_music_volume() -> void:
	if game_data["settings"]["music_volume"] <= -25.0:
		game_data["settings"]["music_volume"] = -80.0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), game_data["settings"]["music_volume"])
	
# Updates the sound effects volume.
func update_sfx_volume() -> void:
	if game_data["settings"]["sfx_volume"] <= -25.0:
		game_data["settings"]["sfx_volume"] = -80.0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), game_data["settings"]["sfx_volume"])
	
# Updates the game volume.
func update_volume_settings() -> void:
	update_global_volume()
	update_music_volume()
	update_sfx_volume()

# Sets the default settings.
func set_default_settings() -> void:
	game_data["settings"] = default_settings.duplicate()

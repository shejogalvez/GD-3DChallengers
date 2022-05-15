extends Node

# Plays an audio stream
static func play(audio : AudioStream, parent : Node) -> void:
	var audio_player = AudioStreamPlayer.new()
	parent.add_child(audio_player)
	audio_player.stream = audio
	audio_player.connect("finished", audio_player, "queue_free")
	audio_player.play()

# Plays an audio stream in a certain 3D position
static func play_3d(audio : AudioStream, position : Vector3, parent : Node, audio_db : float = 0.0, audio_size : float = 1.0) -> void:
	var audio_player = AudioStreamPlayer3D.new()
	parent.add_child(audio_player)
	audio_player.stream = audio
	audio_player.global_transform.origin = position
	audio_player.unit_db = audio_db
	audio_player. unit_size = audio_size
	audio_player.connect("finished", audio_player, "queue_free")
	audio_player.play()
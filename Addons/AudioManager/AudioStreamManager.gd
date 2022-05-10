extends Node

const AUDIO_DB : int = 10
const AUDIO_SIZE : int = 20

# Plays an audio stream
func play(audio : AudioStream, parent : Node):
	var audio_player = AudioStreamPlayer.new()
	parent.add_child(audio_player)
	audio_player.stream = audio
	audio_player.connect("finished", audio_player, "queue_free")
	audio_player.play()

# Plays an audio stream in a certain 3D position
func play_3d(audio : AudioStream, position : Vector3, parent : Node):
	var audio_player = AudioStreamPlayer3D.new()
	parent.add_child(audio_player)
	audio_player.stream = audio
	audio_player.global_transform.origin = position
	audio_player.unit_db = AUDIO_DB
	audio_player. unit_size = AUDIO_SIZE
	audio_player.connect("finished", audio_player, "queue_free")
	audio_player.play()

extends Spatial

export(AudioStream) var break_audio

onready var destruction : Node = $Destruction

# Called when a projectile hits the node.
func projectile_hit(damage, bullet_global_trans):
	AudioStreamManager.play_3d(break_audio, global_transform.origin, get_parent())
	destruction.destroy_with_shards(3)

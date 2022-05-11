extends Spatial

export(AudioStream) var break_audio
export(PackedScene) var pickup_scene

onready var destruction : Node = $Destruction

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

# Called when a projectile hits the node.
func projectile_hit(damage, bullet_global_trans):
	AudioStreamManager.play_3d(break_audio, global_transform.origin, get_parent())
	var xd = rng.randi_range(0, 5)
	for i in range(xd):
		var p = pickup_scene.instance()
		get_tree().root.add_child(p)
		p.global_transform.origin = global_transform.origin
	destruction.destroy_with_shards(3)

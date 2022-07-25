extends RigidBody

export(AudioStream) var break_audio
export(PackedScene) var gold_coin_scene 
export(PackedScene) var health_potion_scene
export(PackedScene) var bomb_scene

var nothing_weight := 30
var gold_coin_weight := 30
var health_potion_weight := 5
var bomb_weight := 5

var pickups := []

onready var destruction : Node = $Destruction

# Append a pickup to the pickups list.
func _append_pickup(node : Node):
	pickups.append(node)

# Generates an array of random pickups.
func _generate_random_pickups() -> void:
	var rfc := RandomFunctionCaller.new()
	rfc.put_void_func(nothing_weight)
	rfc.put_func(gold_coin_weight, self, "_append_pickup", [gold_coin_scene.instance()])
	rfc.put_func(health_potion_weight, self, "_append_pickup", [health_potion_scene.instance()])
	rfc.put_func(bomb_weight, self, "_append_pickup", [bomb_scene.instance()])
	rfc.call_func()
	rfc.free()

# Called when a projectile hits the node.
func projectile_hit(_damage, _bullet_global_trans):
	AudioStreamManager.play_3d(break_audio, global_transform.origin, 10.0, 20.0)
	_generate_random_pickups()
	for pickup in pickups:
		get_tree().root.add_child(pickup)
		pickup.global_transform.origin = global_transform.origin
	destruction.destroy_with_shards(3)

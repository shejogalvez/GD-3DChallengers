extends RigidBody

export(AudioStream) var break_audio
export(PackedScene) var gold_coin_scene 
export(PackedScene) var health_potion_scene

enum Outcomes {NOTHING, COINS, HEALTH_POTION, ATTACK_POTION, SNAKE}

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

onready var destruction : Node = $Destruction

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

# Generates an array of random pickups.
func _generate_random_pickups() -> Array:
	var pickups = []
	var outcome = rng.randi() % Outcomes.size()
	match outcome:
		Outcomes.NOTHING:
			continue
		Outcomes.COINS:
			var amount = rng.randi() % 5
			for _i in amount:
				pickups.append(gold_coin_scene.instance())
		Outcomes.HEALTH_POTION:
			pickups.append(health_potion_scene.instance())
		Outcomes.SNAKE:
			continue
	return pickups
	

# Called when a projectile hits the node.
func projectile_hit(_damage, _bullet_global_trans):
	AudioStreamManager.play_3d(break_audio, global_transform.origin, 10.0, 20.0)
	var pickups = _generate_random_pickups()
	for pickup in pickups:
		get_tree().root.add_child(pickup)
		pickup.global_transform.origin = global_transform.origin
	destruction.destroy_with_shards(3)

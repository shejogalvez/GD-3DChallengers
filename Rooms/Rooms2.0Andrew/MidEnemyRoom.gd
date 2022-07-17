extends RandomRoom

export(PackedScene) var pot_small_scene : PackedScene

export(PackedScene) var bat_enemy_scene : PackedScene
export(PackedScene) var minion_enemy_scene : PackedScene
export(PackedScene) var sand_soldier_scene : PackedScene

var rng := RandomNumberGenerator.new()

var pot_positions := [
	Vector3(99.5, 0.5, 99.5),
	Vector3(94.5, 0.5, 99.5),
	Vector3(99.5, 0.5, 94.5),
	Vector3(-99.5, 0.5, 99.5),
	Vector3(-94.5, 0.5, 99.5),
	Vector3(-99.5, 0.5, 94.5),
	Vector3(99.5, 0.5, -99.5),
	Vector3(94.5, 0.5, -99.5),
	Vector3(99.5, 0.5, -94.5),
	Vector3(-99.5, 0.5, -99.5),
	Vector3(-94.5, 0.5, -99.5),
	Vector3(-99.5, 0.5, -94.5),
	Vector3(69.5, 0.5, 99.5),
	Vector3(64.5, 0.5, 99.5),
	Vector3(69.5, 0.5, 94.5),
	Vector3(-99.5, 0.5, 69.5),
	Vector3(-94.5, 0.5, 69.5),
	Vector3(-99.5, 0.5, 64.5),
	Vector3(99.5, 0.5, -69.5),
	Vector3(94.5, 0.5, -69.5),
	Vector3(99.5, 0.5, -64.5),
	Vector3(-69.5, 0.5, -99.5),
	Vector3(-64.5, 0.5, -99.5),
	Vector3(-69.5, 0.5, -94.5),
	Vector3(99.5, 0.5, 69.5),
	Vector3(94.5, 0.5, 69.5),
	Vector3(99.5, 0.5, 64.5),
	Vector3(-69.5, 0.5, 99.5),
	Vector3(-64.5, 0.5, 99.5),
	Vector3(-69.5, 0.5, 94.5),
	Vector3(69.5, 0.5, -99.5),
	Vector3(64.5, 0.5, -99.5),
	Vector3(69.5, 0.5, -94.5),
	Vector3(-99.5, 0.5, -69.5),
	Vector3(-94.5, 0.5, -69.5),
	Vector3(-99.5, 0.5, -64.5),]

const MIN_POT_AMOUNT := 12
const MAX_POT_AMOUNT := 24

var enemies_positions := [
	Vector3(0, 2.5, 0),
	Vector3(30, 2.5, 0),
	Vector3(0, 2.5, 30),
	Vector3(-30, 2.5, 0),
	Vector3(0, 2.5, -30),
	Vector3(60, 2.5, 60),
	Vector3(-60, 2.5, 60),
	Vector3(-60, 2.5, -60),
	Vector3(60, 2.5, -60),
]

const MIN_ENEMY_AMOUNT := 6
const MAX_ENEMY_AMOUNT := 8

var enemies := []

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	enemies = [bat_enemy_scene, minion_enemy_scene, sand_soldier_scene]
	
# Initializes the room with pots and enemies.
func _init_room():
	_generate_random_pots()
	_generate_random_enemies()

# Generates random pots around the room.
func _generate_random_pots() -> void:
	var pot_amount = rng.randi_range(MIN_POT_AMOUNT, MAX_POT_AMOUNT)
	
	var pot_real_positions = []
	var index = 0
	while index < pot_amount:
		var pot_position = pot_positions[rng.randi_range(0, pot_positions.size() - 1)]
		if not pot_position in pot_real_positions:
			pot_real_positions.append(pot_position)
			index += 1
		
	for position in pot_real_positions:
		var pot_instance : RigidBody = pot_small_scene.instance()
		pot_instance.global_transform.origin = position
		add_child(pot_instance)
		
# Generates random enemies in the center of the room.
func _generate_random_enemies() -> void:
	var enemies_amount = rng.randi_range(MIN_ENEMY_AMOUNT, MAX_ENEMY_AMOUNT)
	
	var enemies_real_positions = []
	var index = 0
	while index < enemies_amount:
		var enemy_position = enemies_positions[rng.randi_range(0, enemies_positions.size() - 1)]
		if not enemy_position in enemies_real_positions:
			enemies_real_positions.append(enemy_position)
			index += 1
			
	index = 0
	while index < enemies_amount:
		var enemy_scene : PackedScene = enemies[rng.randi_range(0, enemies.size() - 1)]
		var enemy : Spatial = enemy_scene.instance()
		enemy.global_transform.origin = enemies_real_positions[index]
		add_child(enemy)
		index += 1

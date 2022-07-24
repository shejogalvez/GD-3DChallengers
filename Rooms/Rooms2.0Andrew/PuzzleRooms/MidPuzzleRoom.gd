extends RandomRoom

export(PackedScene) var pot_small_scene : PackedScene

export(PackedScene) var item_reward: PackedScene

var rng := RandomNumberGenerator.new()
var rota_puzzle := RotaPuzzle.new()

var pot_positions := [
	Vector3(99, 0.5, 99),
	Vector3(84, 0.5, 99),
	Vector3(99, 0.5, 84),
	Vector3(-99, 0.5, 99),
	Vector3(-84, 0.5, 99),
	Vector3(-99, 0.5, 84),
	Vector3(99, 0.5, -99),
	Vector3(84, 0.5, -99),
	Vector3(99, 0.5, -84),
	Vector3(-99, 0.5, -99),
	Vector3(-84, 0.5, -99),
	Vector3(-99, 0.5, -84),
	Vector3(60, 0.5, 70),
	Vector3(60, 0.5, 50),
	Vector3(50, 0.5, 60),
	Vector3(70, 0.5, 60),
	Vector3(-60, 0.5, 70),
	Vector3(-60, 0.5, 50),
	Vector3(-50, 0.5, 60),
	Vector3(-70, 0.5, 60),
	Vector3(60, 0.5, -70),
	Vector3(60, 0.5, -50),
	Vector3(50, 0.5, -60),
	Vector3(70, 0.5, -60),
	Vector3(-60, 0.5, -70),
	Vector3(-60, 0.5, -50),
	Vector3(-50, 0.5, -60),
	Vector3(-70, 0.5, -60)
]

const MIN_POT_AMOUNT := 7
const MAX_POT_AMOUNT := 14

const INITIAL_STATUES_ROTATIONS := 3

onready var stag_statue := $StagStatues/StagStatue
onready var stag_statue_2 := $StagStatues/StagStatue2
onready var stag_statue_3 := $StagStatues/StagStatue3
onready var stag_statue_4 := $StagStatues/StagStatue4
onready var stag_statue_5 := $StagStatues/StagStatue5
onready var stag_statue_6 := $StagStatues/StagStatue6
onready var stag_statue_7 := $StagStatues/StagStatue7
onready var stag_statue_8 := $StagStatues/StagStatue8
onready var reward_position := $RewardPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	stag_statue.set_rota_puzzle(rota_puzzle)
	stag_statue_2.set_rota_puzzle(rota_puzzle)
	stag_statue_3.set_rota_puzzle(rota_puzzle)
	stag_statue_4.set_rota_puzzle(rota_puzzle)
	stag_statue_5.set_rota_puzzle(rota_puzzle)
	stag_statue_6.set_rota_puzzle(rota_puzzle)
	stag_statue_7.set_rota_puzzle(rota_puzzle)
	stag_statue_8.set_rota_puzzle(rota_puzzle)
	
	rota_puzzle.connect("succeded", self, "_end_puzzle")

# Initializes the room with pots and enemies.
func _init_room() -> void:
	_generate_random_pots()
	_move_stag_statues()
	_rotate_stag_statues()

# Called when the player enters the room.
func _player_enter():
	lock_doors()

# Ends the puzzle.
func _end_puzzle() -> void:
	stag_statue.hide_interaction()
	stag_statue_2.hide_interaction()
	stag_statue_3.hide_interaction()
	stag_statue_4.hide_interaction()
	stag_statue_5.hide_interaction()
	stag_statue_6.hide_interaction()
	stag_statue_7.hide_interaction()
	stag_statue_8.hide_interaction()
	
	var item_reward_instance = item_reward.instance()
	add_child(item_reward_instance)
	item_reward_instance.global_transform.origin = reward_position.global_transform.origin

	unlock_doors()

# Moves the fox statues randomly.
func _move_stag_statues() -> void:
	var current_transforms = [
		stag_statue.global_transform,
		stag_statue_2.global_transform,
		stag_statue_3.global_transform,
		stag_statue_4.global_transform,
		stag_statue_5.global_transform,
		stag_statue_6.global_transform,
		stag_statue_7.global_transform,
		stag_statue_8.global_transform
	]
	current_transforms.shuffle()
	stag_statue.global_transform = current_transforms[0]
	stag_statue_2.global_transform = current_transforms[1]
	stag_statue_3.global_transform = current_transforms[2]
	stag_statue_4.global_transform = current_transforms[3]
	stag_statue_5.global_transform = current_transforms[4]
	stag_statue_6.global_transform = current_transforms[5]
	stag_statue_7.global_transform = current_transforms[6]
	stag_statue_8.global_transform = current_transforms[7]

# Rotates the stag statues randomly.
func _rotate_stag_statues() -> void:
	for index in INITIAL_STATUES_ROTATIONS:
		var statue_id = rng.randi_range(0, rota_puzzle.statues.size() - 1)
		rota_puzzle.rotate_statues_instant(statue_id)

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
		add_child(pot_instance)
		pot_instance.global_transform.origin = self.global_transform.origin
		pot_instance.translate(position)
		
		

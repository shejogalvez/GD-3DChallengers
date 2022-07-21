

#const MIN_POT_AMOUNT := 12
#const MAX_POT_AMOUNT := 24
#const MIN_ENEMY_AMOUNT := 8
#const MAX_ENEMY_AMOUNT := 12
extends EnemyRoom


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	enemies = [
		preload("res://enemies/bat/bat.tscn"),
		preload("res://enemies/minion_egipcio/minion_maloglb.tscn"),
		preload("res://enemies/sand_soldier/sand_soldier.tscn"),
	]
	pot_positions = [
	Vector3(129.5, 0.5, 129.5),
	Vector3(124.5, 0.5, 129.5),
	Vector3(129.5, 0.5, 124.5),
	
	Vector3(-129.5, 0.5, 129.5),
	Vector3(-124.5, 0.5, 129.5),
	Vector3(-129.5, 0.5, 124.5),
	
	Vector3(129.5, 0.5, -129.5),
	Vector3(124.5, 0.5, -129.5),
	Vector3(129.5, 0.5, -124.5),
	
	Vector3(-129.5, 0.5, -129.5),
	Vector3(-124.5, 0.5, -129.5),
	Vector3(-129.5, 0.5, -124.5),
	
	Vector3(99.5, 0.5, 129.5),
	Vector3(94.5, 0.5, 129.5),
	Vector3(99.5, 0.5, 124.5),
	
	Vector3(-129.5, 0.5, 99.5),
	Vector3(-124.5, 0.5, 99.5),
	Vector3(-129.5, 0.5, 94.5),
	
	Vector3(129.5, 0.5, -99.5),
	Vector3(124.5, 0.5, -99.5),
	Vector3(129.5, 0.5, -94.5),
	
	Vector3(-99.5, 0.5, -129.5),
	Vector3(-94.5, 0.5, -129.5),
	Vector3(-99.5, 0.5, -124.5),
	
	Vector3(129.5, 0.5, 99.5),
	Vector3(124.5, 0.5, 99.5),
	Vector3(129.5, 0.5, 94.5),
	
	Vector3(-99.5, 0.5, 129.5),
	Vector3(-94.5, 0.5, 129.5),
	Vector3(-99.5, 0.5, 124.5),
	
	Vector3(99.5, 0.5, -129.5),
	Vector3(94.5, 0.5, -129.5),
	Vector3(99.5, 0.5, -124.5),
	
	Vector3(-129.5, 0.5, -99.5),
	Vector3(-124.5, 0.5, -99.5),
	Vector3(-129.5, 0.5, -94.5),]
	
	enemies_positions = [
	Vector3(30, 2.5, 0),
	Vector3(0, 2.5, 30),
	Vector3(-30, 2.5, 0),
	Vector3(0, 2.5, -30),
	Vector3(60, 2.5, 60),
	Vector3(-60, 2.5, 60),
	Vector3(-60, 2.5, -60),
	Vector3(60, 2.5, -60),
	Vector3(90, 2.5, 30),
	Vector3(-90, 2.5, 30),
	Vector3(-90, 2.5, -30),
	Vector3(90, 2.5, -30)
]


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
	
	enemies_positions = [
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

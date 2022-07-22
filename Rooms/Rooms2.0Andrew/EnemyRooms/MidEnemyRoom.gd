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
	
	enemies_positions = [
	Vector3(0, 2.5, 0),
	Vector3(30, 2.5, 0),
	Vector3(0, 2.5, 30),
	Vector3(-30, 2.5, 0),
	Vector3(0, 2.5, -30),
	Vector3(80, 2.5, 80),
	Vector3(-80, 2.5, 80),
	Vector3(-80, 2.5, -80),
	Vector3(80, 2.5, -80),
	]

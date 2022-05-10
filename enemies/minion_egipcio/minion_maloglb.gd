extends IEnemy

onready var animator = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animator.connect("animation_finished", self, "a")
	set_state(initial_state.new())
	
func a(name):
	state.alerted = false


class initial_state extends State:
	
	const follow_distance = 50
	
	func _process(delta):
		var dif = enemy_node.global_transform.origin - PlayerManager.get_player_position()
		if dif.length() < follow_distance and not alerted:
			enemy_node.animator.play("fire_sequence")
			alerted = true
		if alerted:
			enemy_node.face_player()

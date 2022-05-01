extends IEnemy


func _ready():
	self.state = initial_state.new()
	state.start(self)


class initial_state extends State:
	
	var dif_vec : Vector3
	const follow_distance = 3
	
	func _process(delta):
		var dif : Vector3 = .dir_to_player()
		if dif.length() > follow_distance:
			pass

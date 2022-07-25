extends Spatial

export (PackedScene) var teleport : PackedScene = preload("res://Levels/Pedestals/Teleport.tscn")
export (PackedScene) var area_scene : PackedScene = preload("res://Levels/LevelGeneration/Areatp.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# tambien setea un area para avisar cuando entra el player
func set_distance_initial(direction: Vector3, distance : float, offset : float, room):
	var tp = teleport.instance()
	self.add_child(tp)
	tp.translate(Vector3.FORWARD * offset)
	tp.set_teleport_relative_position(direction * (distance + 8) - (offset) * direction)
	var area = area_scene.instance()
	self.add_child(area)
	area.connect("body_entered", room, "_check_player_enter")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_distance_and_signal(direction: Vector3, distance : float, offset : float, room):
	var tp = teleport.instance()
	self.add_child(tp)
	tp.translate(Vector3.FORWARD * offset)
	tp.set_teleport_relative_position(direction * (distance + 8) - (offset) * direction)
	var area = area_scene.instance()
	self.add_child(area)
	area.connect("body_entered", room, "attend_tp_signal")

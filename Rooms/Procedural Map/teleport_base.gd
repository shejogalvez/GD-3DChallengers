extends Spatial

export (PackedScene) var teleport : PackedScene = preload("res://Rooms/Pedestals/Teleport.tscn")
export (PackedScene) var area_scene : PackedScene = preload("res://Rooms/Procedural Map/Areatp.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_distance(direction: Vector3, distance : float, offset : float):
	var tp = teleport.instance()
	self.add_child(tp)
	tp.translate(Vector3.FORWARD * offset)
	tp.set_teleport_relative_position(direction * distance - (offset) * direction)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_distance_and_signal(direction: Vector3, distance : float, offset : float, room):
	set_distance(direction, distance, offset)
	var area = area_scene.instance()
	self.add_child(area)
	area.connect("body_entered", room, "attend_tp_signal")

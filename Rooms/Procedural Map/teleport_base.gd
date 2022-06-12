extends Spatial

export (PackedScene) var teleport : PackedScene = preload("res://Rooms/Pedestals/Teleport.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_distance(direction: Vector3, distance : float, offset : float):
	var tp = teleport.instance()
	self.add_child(tp)
	tp.translate(Vector3.FORWARD * offset)
	tp.set_teleport_relative_position(direction * distance - (offset) * direction)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

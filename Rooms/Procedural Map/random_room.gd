extends Spatial
class_name RandomRoom

var angle = 0
var father
var pos = Vector2()
export (Array, Vector2) var openings
const size = 64.1
const separation = 300

export (PackedScene) var teleport : PackedScene = preload("res://Rooms/Procedural Map/TeleportENbase2.tscn")
export (PackedScene) var wall : PackedScene = preload("res://Rooms/WALL.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initialize(angle: float, father, pos: Vector2):
	self.father = father
	self.angle = angle
	self.pos = pos
	# se añade un tp de vuelta al crearse la sala
	var back_tp = teleport.instance()
	back_tp.translation = -self.global_transform.basis.z * size
	back_tp.rotate_y(PI)
	self.add_child(back_tp)
	
func generate_rooms():
	for opening in openings:
		opening = opening.rotated(angle)
		var newpos = self.pos + opening
		var newangle = -Vector2.DOWN.angle_to(opening)
		print(newpos, newangle)
		if father.is_valid_room(newpos):
			var new_room : RandomRoom = father.construct_room(newpos, newangle)
			new_room.translation = self.separation * Vector3(opening.x, 0, opening.y)
			new_room.initialize(newangle, self.father, newpos)
			self.add_child(new_room)
			var for_tp = teleport.instance()
			for_tp.translation = Vector3(opening.x, 0, opening.y) * size
			for_tp.rotate_y(newangle)
			self.add_child(for_tp)
		else:
			var index = openings.find(opening)
			if index == -1:
				push_warning("opening not found¿ error")
			else:
				openings.remove(index)
			var block = wall.instance()
			block.translation = Vector3(opening.x, 0, opening.y) * size
			block.rotate_y(newangle)
			self.add_child(block)
	father.room_done(self)
	
func set_teleport(teleport, dir):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends Spatial
class_name RoomGenerator

"""class that keeps track of and manages every global aspect of the procedural dungeon"""

var ocuppied_spots = Array()
var rfc : RandomFunctionCaller
export (int) var number_of_rooms = 7
var initial_room : PackedScene = preload("res://Rooms/Procedural Map/initial_room.tscn"  )
var room1p : PackedScene = preload("res://Rooms/Sala2x2Base1P.tscn"  )
var room2pad : PackedScene = preload( "res://Rooms/Sala2x2Base2ADY.tscn" )
var room2pad2 : PackedScene = preload( "res://Rooms/Sala2x2Base2ADY2.tscn" )
var room2pop : PackedScene = preload("res://Rooms/Sala2x2Base2OP.tscn"  )
var room3p : PackedScene = preload( "res://Rooms/Sala2x2Base3P.tscn" )
var room4p : PackedScene = preload("res://Rooms/Sala2x2Base4P.tscn" )

var leaf_rooms = Array()
var actual_room = null
const orientations = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)]

# Called when the node enters the scene tree for the first time.
func _ready():
	rfc = RandomFunctionCaller.new()
	rfc.put_func(0, self, "set_room", [room1p])
	rfc.put_func(1, self, "set_room", [room2pad])
	rfc.put_func(1, self, "set_room", [room2pad])
	rfc.put_func(1, self, "set_room", [room2pop])
	rfc.put_func(1, self, "set_room", [room3p])
	rfc.put_func(1, self, "set_room", [room4p])
	var init = initial_room.instance()
	init.initialize(0, self, Vector2.ZERO)
	self.add_child(init)
	leaf_rooms.append(init)
	ocuppied_spots.append(Vector2(0, 0))
	while(len(leaf_rooms) > 0):
		#print(ocuppied_spots)
		#print(leaf_rooms)
		if (len(leaf_rooms) == 0):
			print("me quee atascao??")
			break
		for room in leaf_rooms:
			if (len(leaf_rooms) == 1):
				rfc.update_weight(0, 0)
			else:
				rfc.update_weight(0, 1)
			room.generate_rooms()
	print(ocuppied_spots)
	print(leaf_rooms)
	
func set_room(preset):
	actual_room = preset.instance()

func is_valid_room(pos:Vector2) -> bool:
	if len(ocuppied_spots) > number_of_rooms:
		print("done")
		return false
	for spot in ocuppied_spots:
		if (spot - pos).length() < 0.1:
			print(pos, "collsion")
			return false
	return true

#func add_room(pos, orientation):
#	if not is_valid_room(pos):
#		return
#	ocuppied_spots.append(pos)
#
#	var room = RandomRoom.new()
#	room.initialize(orientation, orientations, self, pos)
#	leaf_rooms.append()

func construct_room(pos, angle):
	ocuppied_spots.append(pos)
	rfc.call_func()
	leaf_rooms.append(actual_room)
	print("room ", pos, "= ", actual_room)
	return actual_room

func room_done(room):
	var index = leaf_rooms.find(room)
	if index == -1:
		push_warning("room_done error")
		return
	leaf_rooms.remove(index)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

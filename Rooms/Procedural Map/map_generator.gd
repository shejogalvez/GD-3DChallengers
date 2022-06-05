extends Spatial
class_name RoomGenerator

"""class that keeps track of and manages every global aspect of the procedural dungeon"""

var ocuppied_spots = Array()
var rfc : RandomFunctionCaller
export (int) var number_of_rooms = 7
var initial_room : PackedScene = preload("res://Rooms/Procedural Map/initial_room.tscn"  )
var end_room : PackedScene = preload("res://Rooms/Procedural Map/end_room.tscn"  )
var room1p : PackedScene = preload("res://Rooms/Sala2x2Base1P.tscn"  )
var room2pad : PackedScene = preload( "res://Rooms/Sala2x2Base2ADY.tscn" )
var room2pad2 : PackedScene = preload( "res://Rooms/Sala2x2Base2ADY2.tscn" )
var room2pop : PackedScene = preload("res://Rooms/Sala2x2Base2OP.tscn"  )
var room3p : PackedScene = preload( "res://Rooms/Sala2x2Base3P.tscn" )
var room3p2 : PackedScene = preload( "res://Rooms/Sala2x2Base3P2.tscn" )
var room3p3 : PackedScene = preload( "res://Rooms/Sala2x2Base3P3.tscn" )
var room4p : PackedScene = preload("res://Rooms/Sala2x2Base4P.tscn" )

var leaf_rooms = Array()
var actual_room = null
var constructed_rooms = 0
var rooms_tomake = 1
const orientations = [Vector2(0, 1), Vector2(1, 0), Vector2(-1, 0)]
const unique_rooms_n = 8
const initial_weights = [10, 3, 3, 5, 4, 4, 3, 6]
#const initial_weights = [10, 3, 3, 5, 4, 4, 3, 6]

# Called when the node enters the scene tree for the first time.
func _ready():
	rfc = RandomFunctionCaller.new()
	rfc.put_func(initial_weights[0], self, "set_room", [room1p])
	rfc.put_func(initial_weights[1], self, "set_room", [room2pad]) #(-1, 0)
	rfc.put_func(initial_weights[2], self, "set_room", [room2pad2]) #(1, 0)
	rfc.put_func(initial_weights[3], self, "set_room", [room2pop]) #(0, 1)
	rfc.put_func(initial_weights[4], self, "set_room", [room3p])   #(1, 0), (0, 1)
	rfc.put_func(initial_weights[5], self, "set_room", [room3p2])   #(-1, 0), (0, 1)
	rfc.put_func(initial_weights[6], self, "set_room", [room3p3])   #(1, 0), (-1, 0)
	rfc.put_func(initial_weights[7], self, "set_room", [room4p])   #(-1, 0), (1, 0), (0, 1)
	var init = initial_room.instance()
	init.initialize(0, self, Vector2.ZERO)
	self.add_child(init)
	leaf_rooms.append(init)
	ocuppied_spots.append(Vector2(0, 0))
	ocuppied_spots.append(Vector2(0, 1))
	while(len(leaf_rooms) > 0):
		#print(ocuppied_spots)
		print(leaf_rooms)
		var actual_len = len(leaf_rooms)
		for i in range(actual_len):
			var room = leaf_rooms[0]
			room.generate_rooms()
	if (constructed_rooms <= self.number_of_rooms) : print("premature exit")
	print(ocuppied_spots)
	print(constructed_rooms)
	
func set_room(preset):
	actual_room = preset.instance()

func is_valid_room(pos:Vector2) -> bool:
	if constructed_rooms > number_of_rooms:
		print("done")
		return false
#	for spot in ocuppied_spots:
#		if (spot - pos).length() < 0.1:
#			print(pos, "collsion")
#			return false
	return true

func construct_room(pos, angle):
	#ocuppied_spots.append(pos)
	set_avaliable_rooms(pos, angle)
	constructed_rooms += 1
	rooms_tomake -= 1
	#print(rfc.weights)
	var prev = actual_room
	if constructed_rooms > number_of_rooms:
		actual_room = end_room.instance() 
	else:
		while (prev == actual_room):
			rfc.call_func()
	leaf_rooms.append(actual_room)
	rooms_tomake += len(actual_room.openings)
	for orientation in actual_room.openings:
		var dir = orientation.rotated(-angle)
		ocuppied_spots.append(pos + dir)
	reset_pool_values()
	print("room ", pos, "= ", actual_room)
	#print(ocuppied_spots)
	return actual_room

func room_done(room):
	var index = leaf_rooms.find(room)
	if index == -1:
		push_warning("room_done error")
		return
	leaf_rooms.remove(index)

func set_avaliable_rooms(pos, angle):
	var results = [false, false, false]
	for i in range(3):
		var dir = orientations[i].rotated(-angle)
		print(pos, dir)
		for spot in ocuppied_spots:
			if (spot - (pos + dir)).length() < 0.1:
				print(spot, " already taken ", i)
				results[i] = true
				break
	update_room_pool(results)
	
	
# orientations = [(0, 1), (1, 0), (-1, 0)]
#	rfc.put_func(0, self, "set_room", [room1p]) 0
#	rfc.put_func(1, self, "set_room", [room2pad]) #(-1, 0)  1
#	rfc.put_func(1, self, "set_room", [room2pad]) #(1, 0)  2 
#	rfc.put_func(1, self, "set_room", [room2pop]) #(0, 1)  3
#	rfc.put_func(1, self, "set_room", [room3p])   #(1, 0), (0, 1)  4
#	rfc.put_func(1, self, "set_room", [room3p2])   #(-1, 0), (0, 1)  5
#	rfc.put_func(1, self, "set_room", [room3p3])   #(1, 0), (-1, 0)  6
#	rfc.put_func(1, self, "set_room", [room4p])   #(-1, 0), (1, 0), (0, 1)  7
func update_room_pool(bool_array):
	if (rooms_tomake <= 1):
		rfc.update_weight(0, 0)
	else:
		rfc.update_weight(0, initial_weights[0])
	if bool_array[0]:
		rfc.update_weight(3, 0)
		rfc.update_weight(4, 0)
		rfc.update_weight(5, 0)
		rfc.update_weight(7, 0)
	if bool_array[1]:
		rfc.update_weight(2, 0)
		rfc.update_weight(4, 0)
		rfc.update_weight(6, 0)
		rfc.update_weight(7, 0)
	if bool_array[2]:
		rfc.update_weight(1, 0)
		rfc.update_weight(5, 0)
		rfc.update_weight(6, 0)
		rfc.update_weight(7, 0)
		
func reset_pool_values():
	for i in range(unique_rooms_n):
		rfc.update_weight(i, initial_weights[i])
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

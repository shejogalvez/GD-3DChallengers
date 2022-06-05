extends Spatial
class_name RoomGenerator

"""class that keeps track of and manages every global aspect of the procedural dungeon"""

var reserved_spots = Array()
var occupied_spots = Array()
var rfc : RandomFunctionCaller
var rfc_rooms : RandomFunctionCaller
export (int) var number_of_rooms = 12
var random_rooms = [
	[preload("res://Rooms/Sala2x2Base4P.tscn"), 1] ,
	[preload("res://Rooms/Sala2x2Base4Pbig.tscn"), 1] 
]

var obligatory_rooms = [
	[preload("res://Rooms/Procedural Map/end_room.tscn"), [12]]
]
var obligatory_rooms_queue : Array
var initial_room : PackedScene = preload("res://Rooms/Procedural Map/initial_room.tscn"  )

const front = Vector2.DOWN
const right = Vector2.LEFT
const left = Vector2.RIGHT

var possible_orientations = [
	[], [right], [left], [front], [left, front], [right, front], [left, right], [right, left, front]
]
var unique_orientations = len(possible_orientations)
export (int) var nonew = 15
export (int) var rightw = 5
export (int) var leftw = 5
export (int) var frontw = 9
export (int) var left_frontw = 4
export (int) var right_frontw = 4
export (int) var left_rightw = 3
export (int) var right_left_frontw = 5
var initial_weights = []

var leaf_rooms = Array()
var actual_room = null
var actual_orientations = null
var constructed_rooms = 0
var rooms_tomake = 1
const orientations = [Vector2(0, 1), Vector2(1, 0), Vector2(-1, 0)]

# Called when the node enters the scene tree for the first time.
func _ready():
	set_initial_weights()
	rfc = RandomFunctionCaller.new()
	rfc_rooms = RandomFunctionCaller.new()
	for i in range(unique_orientations):
		rfc.put_func(initial_weights[i], self, "set_orientation", [possible_orientations[i]])
	for room in random_rooms:
		rfc_rooms.put_func(room[1], self, "set_room", [room[0]])
		
	
	var init = initial_room.instance()
	init.initialize(0, self, Vector2.ZERO)
	self.add_child(init)
	leaf_rooms.append(init)
	reserved_spots.append(Vector2(0, 0))
	reserved_spots.append(Vector2(0, 1))
	occupied_spots.append(Vector2(0, 0))
	set_obligatory_rooms()
	while(len(leaf_rooms) > 0):
		if (rooms_tomake <= 1):
			rfc.update_weight(0, 0)
		else:
			rfc.update_weight(0, initial_weights[0])
		#print(reserved_spots)
		print(leaf_rooms)
		var actual_len = len(leaf_rooms)
		for i in range(actual_len):
			var room = leaf_rooms[0]
			room.generate_rooms()
	if (constructed_rooms <= self.number_of_rooms) : print("premature exit")
	print(reserved_spots)
	print(constructed_rooms)
	
func set_initial_weights():
	initial_weights = [nonew, rightw, leftw, frontw, left_frontw, right_frontw, left_rightw, right_left_frontw]
	
class MyCustomSorter:
	static func sort_hint_ascending(a, b):
		if a[1] < b[1]:
			return true
		return false

func set_obligatory_rooms():
	for room in obligatory_rooms:
		for hint in room[1]:
			obligatory_rooms_queue.append([room[0], hint])
	obligatory_rooms_queue.sort_custom(MyCustomSorter, "sort_hint_ascending")

func set_room(preset):
	actual_room = preset.instance()
	
func set_orientation(orientation):
	print(orientation)
	actual_orientations = orientation

func is_valid_room(pos:Vector2) -> bool:
	if constructed_rooms > number_of_rooms:
		print("done")
		return false
	for spot in occupied_spots:
		if (spot - pos).length() < 0.1:
			print(pos, "collsion", (spot - pos).length())
			return false
	return true

func construct_room(pos, angle):
	#reserved_spots.append(pos)
	set_avaliable_rooms(pos, angle)
	constructed_rooms += 1
	occupied_spots.append(pos)
	rooms_tomake -= 1
	var prev = actual_room
	var prev_or = actual_orientations
	
	if(len(obligatory_rooms_queue)) > 0:
		if constructed_rooms == obligatory_rooms_queue[0][1]:
			actual_room = (obligatory_rooms_queue[0][0]).instance() 
			actual_orientations = actual_room.openings
			var last_room = obligatory_rooms_queue.pop_front()
			if(len(obligatory_rooms_queue)) > 0:
				while obligatory_rooms_queue[0][1] == last_room[1]:
					push_warning("repeated hints for obligatory rooms")
					last_room = obligatory_rooms_queue.pop_front()
		else:
			while (prev == actual_room):
				rfc_rooms.call_func()
				rfc.call_func()
	else:
		while (prev == actual_room):
			rfc_rooms.call_func()
			rfc.call_func()
	print(actual_orientations)
	actual_room.set_openings(actual_orientations)
	leaf_rooms.append(actual_room)
	rooms_tomake += len(actual_room.openings)
	for orientation in actual_room.openings:
		var dir = orientation.rotated(-angle)
		reserved_spots.append(pos + dir)
	reset_pool_values()
	print("room ", pos, "= ", actual_room)
	#print(reserved_spots)
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
		#print(pos, dir)
		for spot in reserved_spots:
			if (spot - (pos + dir)).length() < 0.2:
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
	for i in range(unique_orientations):
		rfc.update_weight(i, initial_weights[i])
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

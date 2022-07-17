extends Spatial
class_name RoomGenerator

"""class that keeps track of and manages every global aspect of the procedural dungeon"""

var rfc : RandomFunctionCaller
var rfc_rooms : RandomFunctionCaller
export (int) var number_of_rooms = 12
var random_rooms = [
	[preload("res://Rooms/Sala2x2Base4P.tscn"), 1] ,
	[preload("res://Rooms/Sala2x2Base4Pbig.tscn"), 1] 
]

# end_room SIMPRE VA PRIMERO!!
var obligatory_rooms = [
	[preload("res://Rooms/Procedural Map/end_room.tscn"), [12]],
]
var obligatory_rooms_queue = Array()
export (PackedScene) var initial_room : PackedScene = preload("res://Rooms/Procedural Map/initial_room.tscn"  )




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


var reserved_spots = Array()
var occupied_spots = Array()
var leaf_rooms = Array()
var actual_room = null
var actual_orientations = null
var constructed_rooms = 0
var constructed_rooms_array = Array()
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
		
	reset_pool_values()
	var init = initial_room.instance()
	init.initialize(0, self, Vector2.ZERO)
	self.add_child(init)
	constructed_rooms_array.append(init)
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
		var actual_len = len(leaf_rooms)
		for i in range(actual_len):
			var room = leaf_rooms[0]
			room.generate_rooms()
		if (constructed_rooms < self.number_of_rooms) and len(leaf_rooms) == 0:
			print("premature exit")
			var i = 0
			while not create_emergency_exit(constructed_rooms - i):
				i+=1
			#init.queue_free()
			#reset()
	#print(constructed_rooms, constructed_rooms_array)
	
func reset():
	reserved_spots = []
	occupied_spots = []
	leaf_rooms = []
	actual_room = null
	actual_orientations = null
	constructed_rooms = 0
	rooms_tomake = 1
	obligatory_rooms_queue = []

# tries to create a new teleport/room on indexth room created, return true if succeed
func create_emergency_exit(index) -> bool:
	var room = constructed_rooms_array[index]
	#print(room, room.pos)
	return room.open_exit()
	
func set_initial_weights():
	initial_weights = [nonew, rightw, leftw, frontw, left_frontw, right_frontw, left_rightw, right_left_frontw]
	
class MyCustomSorter:
	static func sort_hint_ascending(a, b):
		if a[1] < b[1]:
			return true
		return false

func set_obligatory_rooms():
	obligatory_rooms[0][1] = [number_of_rooms]
	for room in obligatory_rooms:
		for hint in room[1]:
			obligatory_rooms_queue.append([room[0], hint])
	obligatory_rooms_queue.sort_custom(MyCustomSorter, "sort_hint_ascending")

func set_room(preset):
	actual_room = preset.instance()
	
func set_orientation(orientation):
	#print(orientation)
	actual_orientations = orientation

func is_valid_room(pos:Vector2) -> bool:
	if constructed_rooms >= number_of_rooms:
		#print("done")
		return false
	for spot in occupied_spots:
		if (spot - pos).length() < 0.2:
			#print(pos, "collsion", (spot - pos).length())
			return false
	return true

func construct_room(pos, angle):
	#reserved_spots.append(pos)
	constructed_rooms += 1
	occupied_spots.append(pos)
	rooms_tomake -= 1
	var prev = actual_room
	# checks if is turn for obligatory room
	if(len(obligatory_rooms_queue)) > 0 and constructed_rooms >= obligatory_rooms_queue[0][1]:
		actual_room = (obligatory_rooms_queue[0][0]).instance() 
		actual_room.possible_openings = actual_room.openings
		actual_orientations = actual_room.openings
		#set_available_from_openings(pos, angle, actual_room.openings)
		#rfc.call_func()
		var last_room = obligatory_rooms_queue.pop_front()
		if(len(obligatory_rooms_queue)) > 0:
			while obligatory_rooms_queue[0][1] == last_room[1]:
				push_warning("repeated hints for obligatory rooms")
				last_room = obligatory_rooms_queue.pop_front()
	# else creates a random room
	else:
		while (prev == actual_room):
			#set_avaliable_rooms(pos, angle)
			rfc_rooms.call_func()
			rfc.call_func()
	#print(actual_orientations)
	actual_room.set_openings(actual_orientations)
	leaf_rooms.append(actual_room)
	rooms_tomake += len(actual_room.openings)
#	for orientation in actual_room.openings:
#		var dir = orientation.rotated(-angle)
#		reserved_spots.append(pos + dir)
#	reset_pool_values()
	#print("room ", pos, "= ", actual_room)
	constructed_rooms_array.append(actual_room)
	#print(reserved_spots)
	return actual_room

func room_done(room):
	var index = leaf_rooms.find(room)
	if index == -1:
		push_warning("room_done error")
		return
	leaf_rooms.remove(index)
	
	
	
##################### UNUSED #############################
##################### UNUSED #############################
##################### UNUSED #############################

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
	
	
func set_available_from_openings(pos, angle, hint):
	var results = [false, false, false]
	for i in range(3):
		for j in range(len(hint)):
			if (hint[j] - orientations[i]).length() < 0.2:
				break
			results[i] = true
		if !results[i]:
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

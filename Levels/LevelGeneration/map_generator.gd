extends Spatial
class_name RoomGenerator

export (PackedScene) var initial_room : PackedScene = preload("res://Levels/Rooms/ExtraRooms/InitialRoom.tscn")

export (int) var number_of_rooms = 10


var rfc : RandomFunctionCaller
var rfc_rooms : RandomFunctionCaller

var random_rooms = [
	[preload("res://Levels/Rooms/EnemyRooms/SmallEnemyRoom.tscn"), 20] ,
	[preload("res://Levels/Rooms/EnemyRooms/SmallEnemyRoomB.tscn"), 20] ,
	[preload("res://Levels/Rooms/EnemyRooms/SmallEnemyRoomC.tscn"), 20] ,
	[preload("res://Levels/Rooms/EnemyRooms/SmallEnemyRoomD.tscn"), 20] ,
	[preload("res://Levels/Rooms/PuzzleRooms/SmallPuzzleRoom.tscn"), 30] ,
	[preload("res://Levels/Rooms/PuzzleRooms/MidPuzzleRoom.tscn"), 30] ,
	[preload("res://Levels/Rooms/EnemyRooms/MidEnemyRoom.tscn"), 30]
]

# end_room SIMPRE VA PRIMERO!!
var obligatory_rooms = [
	[preload("res://Levels/Rooms/BossRooms/BigBossRoom.tscn"), [12]],
]
var obligatory_rooms_queue = Array()


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

onready var minimap = $GUI/Control/ViewportContainer/Viewport/minimap
onready var minimap_camera : Camera2D = $GUI/Control/ViewportContainer/Viewport/minimap/Camera2D
var minimap_door = preload("res://Levels/LevelGeneration/minimap/door.tscn")
var actual_pos : Vector2 = Vector2.ZERO
const minimap_separation = 120
const real_separation = 400


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.current_level = self
	
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

	#print(constructed_rooms, constructed_rooms_array)
	
# Resets.
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
	
	constructed_rooms += 1
	occupied_spots.append(pos)
	rooms_tomake -= 1
	var prev = actual_room
	# checks if is turn for obligatory room
	if(len(obligatory_rooms_queue)) > 0 and constructed_rooms >= obligatory_rooms_queue[0][1]:
		actual_room = (obligatory_rooms_queue[0][0]).instance() 
		actual_room.possible_openings = actual_room.openings
		actual_orientations = actual_room.openings

		var last_room = obligatory_rooms_queue.pop_front()
		if(len(obligatory_rooms_queue)) > 0:
			while obligatory_rooms_queue[0][1] == last_room[1]:
				push_warning("repeated hints for obligatory rooms")
				last_room = obligatory_rooms_queue.pop_front()
	# else creates a random room
	else:
		while (prev == actual_room):
			rfc_rooms.call_func()
			rfc.call_func()

	actual_room.set_openings(actual_orientations)
	leaf_rooms.append(actual_room)
	rooms_tomake += len(actual_room.openings)

	constructed_rooms_array.append(actual_room)
	
	return actual_room

func room_done(room):
	var index = leaf_rooms.find(room)
	if index == -1:
		push_warning("room_done error")
		return
	leaf_rooms.remove(index)
	add_to_minimap(room.sprite, room.pos)


func add_to_minimap(sprite : Texture, pos : Vector2):
	var room = Sprite.new()
	room.texture = sprite
	minimap.add_child(room)
	room.translate(pos * minimap_separation)
	room.rotate(PI)
	room.z_index = 1

func center_minimap_in(pos : Vector2):
	minimap_camera.position = pos * minimap_separation
	actual_pos = pos

func add_door(pos : Vector2, room_size : float, opening : Vector2):
	var door = minimap_door.instance()
	minimap.add_child(door)
	door.translate(pos * minimap_separation + opening * room_size)
	
##################### UNUSED #############################
##################### UNUSED #############################
##################### UNUSED #############################
	
	
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


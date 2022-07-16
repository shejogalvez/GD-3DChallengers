extends Spatial
class_name RandomRoom

var angle = 0
var father
var pos = Vector2()
export (float) var size = 64.1
export (float) var tp_offset = 15
export (Array, Vector2) var openings
var global_size = size
const separation = 300
const size_variation = 2
var possible_openings = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, 1)]
var scale_factor = 1

var unused_openings = Array()

export (PackedScene) var teleport : PackedScene = preload("res://Rooms/Procedural Map/TeleportENbase2.tscn")
export (PackedScene) var wall : PackedScene = preload("res://Rooms/WALL.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Initializes the room.
func _init_room():
	pass
	
func set_openings(openings_set):
	openings = openings_set

func initialize(angle: float, father, pos: Vector2, father_node : RandomRoom = null):
	self.father = father
	self.angle = angle
	self.pos = pos
	#scale_factor = rand_range(1, size_variation)
	#self.size = scale_factor * base_size
	#self.scale = Vector3((self.scale.x * scale_factor)  / prev_scale, 1, (self.scale.z * scale_factor)  / prev_scale)
	#print(self.scale, " ", prev_scale)
	#global_size = size * scale_factor
	# se añade un tp de vuelta al crearse la sala
	var back_tp = teleport.instance()
	back_tp.translation = Vector3.FORWARD * size
	back_tp.rotate_y(PI)
	var orientation = Vector2(0, -1).rotated(-angle)
	var orient_v3 = Vector3(orientation.x, 0, orientation.y) 
	back_tp.set_distance(orient_v3, separation - size - father_node.size, tp_offset)
	self.add_child(back_tp)
	
func generate_rooms():
	possible_openings.shuffle()
	for opening in possible_openings:
		var rel_opening = opening
		var new_opening = opening.rotated(-angle)
		#print(opening, angle, new_opening, self.rotation)
		var newpos = self.pos + new_opening
		var newangle = -Vector2.DOWN.angle_to(new_opening)
		var relangle = newangle - self.angle
		#print(self,self.pos, " creando sala en posicion " , newpos, ", angulo absoluto %f y relativo %f"  % [newangle, relangle])
		
		var check_in = false
		for op in self.openings:
			if (opening - op).length() < 0.1:
				#print(self, opening)
				check_in = true
				break
		if check_in and father.is_valid_room(newpos):
			#print(self,self.pos, " creando sala en posicion " , newpos, ", angulo absoluto %f y relativo %f"  % [newangle, relangle])
			add_childroom(rel_opening, new_opening, relangle, newangle, newpos)
			
		else:
			var block = wall.instance()
			block.translation = Vector3(opening.x, 0, opening.y) * size
			block.rotate_y(relangle)
			unused_openings.append([opening, block])
			self.add_child(block)
			
	father.room_done(self)

func add_childroom(rel_opening, new_opening, relangle, newangle, newpos):
	var new_room : RandomRoom = father.construct_room(newpos, newangle)
	new_room.translation = self.separation/scale_factor * Vector3(rel_opening.x, 0, rel_opening.y)
	new_room.rotate_y(relangle)
	new_room.initialize(newangle, self.father, newpos, self)
	self.add_child(new_room)
	#print("origin = ", new_room.global_transform.origin)
	var for_tp = teleport.instance()
	for_tp.translation = Vector3(rel_opening.x, 0, rel_opening.y) * size
	for_tp.rotate_y(relangle)
	var new_op_v3 = Vector3(new_opening.x, 0, new_opening.y)
	for_tp.set_distance(new_op_v3, separation - size - new_room.size, tp_offset) 
	self.add_child(for_tp)
	
func open_exit() -> bool:
	for opening in unused_openings:
		var rel_opening = opening[0]
		var new_opening = rel_opening.rotated(-angle)
		var newpos = self.pos + new_opening
		print("emergency exit  ", opening, angle, newpos, self)
		var newangle = -Vector2.DOWN.angle_to(new_opening)
		var relangle = newangle - self.angle
		if father.is_valid_room(newpos):
			opening[1].queue_free()
			add_childroom(rel_opening, new_opening, relangle, newangle, newpos)
	return false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

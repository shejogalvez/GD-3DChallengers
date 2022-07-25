extends Spatial
class_name RandomRoom

var angle = 0
var father
var pos = Vector2()
export (float) var size = 64.1
export (float) var tp_offset = 15
export (float) var sprite_size = 33
export (Texture) var sprite = preload("res://Assets/Trash/room_sprite.png")
export (Array, Vector2) var openings
var global_size = size
var separation = 400
const size_variation = 2
var possible_openings = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, 1)]
var scale_factor = 1

var unused_openings = Array()
var used_openings := Array() # save pairs dir, angle in local space
var locks_array := Array()

export (PackedScene) var teleport : PackedScene = preload("res://Levels/LevelGeneration/TeleportENbase2.tscn")
export (PackedScene) var wall : PackedScene = preload("res://Levels/LevelGeneration/ParedRelleno.tscn")
export (PackedScene) var lock_scene : PackedScene = preload("res://Levels/LevelGeneration/door_lock.tscn")
var filled : bool = false
var player_entered : = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Initializes the room.
func _init_room():
	#print("room ", self, " pos: ", pos, " initializated")
	pass
	
func _player_enter():
	pass

func lock_doors():
	for opening in used_openings:
		var block = lock_scene.instance()
		block.translation = Vector3(opening[0].x, 0, opening[0].y) * size
		block.rotate_y(opening[1])
		self.add_child(block)
		locks_array.append(block)

func unlock_doors():
	for block in locks_array:
		block.queue_free()

func attend_tp_signal(body):
	if body == PlayerManager.get_player() and not filled:
		self._init_room()
		filled = true

func _check_player_enter(body):
	if body == PlayerManager.get_player() and not player_entered:
		self._player_enter()
		player_entered = true
	

func center_minimap_to_me():
	father.center_minimap_in(self.pos)

func set_openings(openings_set):
	openings = openings_set

func initialize(angle: float, father, pos: Vector2, father_node : RandomRoom = null):
	used_openings.append([Vector2(0,-1), PI])
	self.father = father
	#separation = father.real_separation
	self.angle = angle
	self.pos = pos
	
	var back_tp = teleport.instance()
	back_tp.translation = Vector3.FORWARD * size
	back_tp.rotate_y(PI)
	var orientation = Vector2(0, -1).rotated(-angle)
	# le indica al room_generetor que haga una puerta en self.pos con direccion orientation
	father.add_door(self.pos, sprite_size, orientation)
	var orient_v3 = Vector3(orientation.x, 0, orientation.y) 
	back_tp.set_distance_initial(orient_v3, separation - size - father_node.size, tp_offset, self)
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
	# le indica que termina y se coloca en minimapa
	father.room_done(self)

func add_childroom(rel_opening, new_opening, relangle, newangle, newpos):
	# guarda en used openings
	used_openings.append([rel_opening, relangle])
	# le indica al room_generetor que haga una puerta en self.pos con direccion new_opening
	father.add_door(self.pos, sprite_size, new_opening)
	
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
	for_tp.set_distance_and_signal(new_op_v3, separation - size - new_room.size, tp_offset, new_room) 
	self.add_child(for_tp)
	
func open_exit() -> bool:
	for opening in unused_openings:
		var rel_opening = opening[0]
		var new_opening = rel_opening.rotated(-angle)
		var newpos = self.pos + new_opening
		#print("emergency exit  ", opening, angle, newpos, self)
		var newangle = -Vector2.DOWN.angle_to(new_opening)
		var relangle = newangle - self.angle
		if father.is_valid_room(newpos):
			opening[1].queue_free()
			add_childroom(rel_opening, new_opening, relangle, newangle, newpos)
	return false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends KinematicBody

onready var area := $Area
onready var animation_player := $AnimationPlayer
var n 
var player = null
var motion = Vector3()
const GRAVITY := -200
var state = 0 

var path = []
var path_node = 0
onready var nav = get_parent()
#var start_point = Vector3(0, 0, 0)
#var end_point = Vector3(4, 0, 4)

const RAT_SPEED := 0.07

# Called when the node enters the scene tree for the first time.
func _ready():
	area.connect("body_entered", self, "_girar")

func _girar(body):
	print("Choque con area D:")
	n = rand_range(25,200)
	rotate_y(n)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		
	global_transform.origin = global_transform.origin + global_transform.basis.z * RAT_SPEED
	
	_process_animations(delta)
	
	#	end_point = Vector3()
	#if transform.origin < end_point:
	#	var direction = transform.origin.linear_interpolate(end_point, delta * RAT_SPEED)
	#	direction.x = direction.x * -1
	#	direction.z = direction.z * -1
	#	direction.y = transform.origin.y
	#	look_at(direction, Vector3.UP)
	#	transform.origin = direction

func _physics_process(delta):
	state = rand_range(0,2)
	if state == 0:
		pass
	elif state == 1:
		if player:
			motion = -1 * player.global_transform.origin * RAT_SPEED
		motion.y = delta * GRAVITY
	motion = move_and_slide(motion)
	
#func move_away(target_pos):
#	if player:
#		motion= (self.global_transform.origin - target_pos)
#	motion = move_and_slide(motion)
#	path = nav.get_simple_path(global_transform.origin, target_pos)
#	path_node = 0
	
func _process_animations(delta):
	animation_player.play("Rat_Jump")

func _on_Area_body_entered(body):
	player = body

func _on_Area_body_exited(body):
	player = body

#func _on_Timer_timeout():
#	move_away(PlayerManager.get_player_position())


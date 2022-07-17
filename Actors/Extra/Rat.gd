extends KinematicBody

onready var area := $Area
onready var animation_player := $AnimationPlayer

#var start_point = Vector3(0, 0, 0)
#var end_point = Vector3(4, 0, 4)

const RAT_SPEED := 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	area.connect("body_entered", self, "_girar")

func _girar(body):
	print("Choque con area D:")
	rotate_y(90)

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

func _process_animations(delta):
	animation_player.play("Rat_Walk")

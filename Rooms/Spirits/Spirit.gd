extends MeshInstance

export(float, 0.0, 999.0) var spirit_speed := 1.0

var initial_position := Vector3(0, 0, 0)
var moves_queue := []
var current_move_target = null
var queued_dissapear := false

const CLOSE_DISTANCE = 2

onready var interaction := $Interaction
onready var animation_player := $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_position = global_transform.origin

# Called on each frame.
func _process(delta):
	if current_move_target != null:
		global_transform.origin = global_transform.origin.linear_interpolate(current_move_target, delta * spirit_speed)
		if (global_transform.origin - current_move_target).length() < CLOSE_DISTANCE:
			current_move_target = null
	else:
		if !moves_queue.empty():
			current_move_target = moves_queue.pop_front()
		elif queued_dissapear:
			animation_player.play_backwards("appear")
			queued_dissapear = false

# Appears.
func appear() -> void:
	interaction.set_collision_mask_bit(6, true)
	animation_player.play("appear")

# Moves instantly to a target.
func move(move_target : Vector3) -> void:
	reset_movement()
	queue_move(move_target)

# Moves instantly to the initial position.
func move_initial() -> void:
	reset_movement()
	queue_move_initial()

# Queues a movement to a target.
func queue_move(move_target : Vector3) -> void:
	interaction.set_collision_mask_bit(6, false)
	moves_queue.push_back(move_target)

# Queues a movement to the initial position.
func queue_move_initial() -> void:
	interaction.set_collision_mask_bit(6, false)
	moves_queue.push_back(initial_position)

# Queues a dissapear animation.
func queue_dissapear() -> void:
	interaction.set_collision_mask_bit(6, false)
	queued_dissapear = true

# Resets the movement queue.
func reset_movement() -> void:
	moves_queue.clear()
	current_move_target = null
	queued_dissapear = false

# Interacts with the node.
func interact() -> void:
	if get_parent().has_method("spirit_interact"):
		get_parent().spirit_interact()
	

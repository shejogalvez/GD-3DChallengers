extends StaticBody
class_name StatueRotate

const ROTATION_ANGLES := 90
const ROTATION_SPEED := 2.0

export(int) var rotation_id := 0
export(Array, int) var rotated_statues_ids = []

var current_rotation := 0
var left_rotation := 0.0
var rota_puzzle : RotaPuzzle

onready var interaction := $Interaction

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called on each frame.
func _process(delta):
	if left_rotation > 0:
		left_rotation -= 1 * ROTATION_SPEED
		rotate_y(deg2rad(1 * ROTATION_SPEED))

# Sets the rota puzzle.
func set_rota_puzzle(rota_puzzle : RotaPuzzle) -> void:
	self.rota_puzzle = rota_puzzle
	rota_puzzle.add_statue(self)

# Rotates the statue instantly.
func rotate_instant() -> void:
	current_rotation += ROTATION_ANGLES
	rotate_y(deg2rad(ROTATION_ANGLES))

# Rotates the statue smoothly.
func rotate_smooth() -> void:
	current_rotation += ROTATION_ANGLES
	left_rotation += ROTATION_ANGLES

# Returns true if the statue is well rotated.
func is_well_rotated() -> bool:
	return current_rotation % 360 == 0

# Shows the interaction.
func show_interaction() -> void:
	interaction.set_collision_mask_bit(6, true)

# Hides the interaction.
func hide_interaction() -> void:
	interaction.set_collision_mask_bit(6, false)

# Interacts with the node.
func interact():
	if rota_puzzle == null:
		return
	rota_puzzle.rotate_statues_smooth(rotation_id)
	

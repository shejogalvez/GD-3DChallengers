extends Object
class_name RotaPuzzle

signal advanced
signal succeded

var start := true
var statues := {}

# Initializes the node.
func _init():
	pass

# Adds a rotational statue to the list.
func add_statue(statue) -> void:
	statues[statue.rotation_id] = statue

# Rotates statues smoothly.
func rotate_statues_smooth(statue_id : int) -> void:
	if !start:
		return
	for rotated_statue_id in statues[statue_id].rotated_statues_ids:
		statues[rotated_statue_id].rotate_smooth()
	if _rotations_succeded():
		start = false
		emit_signal("succeded")
	else:
		emit_signal("advanced")

# Rotates statues instantly.
func rotate_statues_instant(statue_id : int) -> void:
	for rotated_statue_id in statues[statue_id].rotated_statues_ids:
		statues[rotated_statue_id].rotate_instant()

# Returns true if all statues are in the correspondent rotation.
func _rotations_succeded() -> bool:
	for statue in statues.values():
		if !statue.is_well_rotated():
			return false
	return true

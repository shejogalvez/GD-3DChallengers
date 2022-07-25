extends StaticBody

export(int, 0, 99) var rank := 0 

var memo_puzzle : MemoPuzzle

onready var nose_position := $NosePosition
onready var interaction := $Interaction

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_interaction()

# Sets the memo puzzle.
func set_memo_puzzle(memo_puzzle : MemoPuzzle) -> void:
	self.memo_puzzle = memo_puzzle

# Shows the interaction.
func show_interaction() -> void:
	interaction.set_collision_mask_bit(6, true)

# Hides the interaction.
func hide_interaction() -> void:
	interaction.set_collision_mask_bit(6, false)

# Gets the nose position.
func get_nose_position() -> Vector3:
	return nose_position.global_transform.origin

# Interacts with the node.
func interact():
	if memo_puzzle == null:
		return
	if memo_puzzle.get_count() == rank:
		memo_puzzle.advance()
	else:
		memo_puzzle.fail()

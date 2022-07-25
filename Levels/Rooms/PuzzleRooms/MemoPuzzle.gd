extends Object
class_name MemoPuzzle

signal advanced
signal succeded
signal failed

var goal : int 
var count := 0
var start := false

# Initializes the node.
func _init(goal : int):
	self.goal = goal

# Gets the current puzzle count.
func get_count() -> int:
	return count

# Starts the puzzle.
func start() -> void:
	start = true
	count = 0

# Advances in the count.
func advance() -> void:
	if !start:
		return
	count += 1
	if count == goal:
		start = false
		count = 0
		emit_signal("succeded")
	else:
		emit_signal("advanced")
	
# Fails the count.
func fail() -> void:
	if !start:
		return
	start = false
	count = 0
	emit_signal("failed")

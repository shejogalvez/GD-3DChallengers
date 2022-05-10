extends RigidBody

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_central_impulse(translation * 10)

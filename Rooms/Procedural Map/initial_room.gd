extends RandomRoom

# Called when the node enters the scene tree for the first time.
func _ready():
	self.openings = [Vector2(0, 1)]

func initialize(angle: float, father, pos: Vector2,  father_node : RandomRoom = null):
	self.father = father
	self.angle = angle
	self.pos = pos
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

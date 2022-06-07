extends State
class_name Wait

var hit : bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _init(hit : bool = true):
	self.hit = hit
	
func projectile_hit(damage, global_trans):
	if hit:
		print(hit)
		enemy_node.hp -= damage
		if enemy_node.hp <= 0:
			enemy_node.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

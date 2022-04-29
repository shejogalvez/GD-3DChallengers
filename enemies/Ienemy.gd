extends KinematicBody


var hp : int
var alerted : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func bullet_hit(damage, bullet_global_trans):
	alerted = true
	hp -= damage
	if hp<=0:
		self.queue_free()

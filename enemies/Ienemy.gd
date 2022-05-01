extends KinematicBody
class_name IEnemy

var hp : int
var alerted : bool

var state : State

func _ready():
	pass # Replace with function body.

func bullet_hit(damage, bullet_global_trans):
	state.bullet_hit(damage, bullet_global_trans)


extends Node
class_name State

var enemy_node #: IEnemy
var alerted : bool
var raycast : RayCast 

func start(node):
	self.enemy_node = node
	self.alerted = false
	self.raycast = enemy_node.raycast

func projectile_hit(damage, global_trans):
	enemy_node.hp -= damage
	if enemy_node.hp <= 0:
		enemy_node.queue_free()

func _process(delta):
	pass

func _physics_process(delta):
	pass
	

extends Node
class_name State

var enemy_node #: IEnemy
var alerted : bool
var raycast : RayCast 
const damage_label : PackedScene = preload("res://enemies/Damage_Label.tscn")

func start(node):
	self.enemy_node = node
	self.alerted = false
	self.raycast = enemy_node.raycast

func projectile_hit(damage, global_trans):
	enemy_node.hp -= damage
	var label = damage_label.instance()
	label.set_text(str(damage))
	label.set_size(enemy_node.vec_to_player2d().length() * 0.35)
	label.set_float_dir(enemy_node.vec_to_player2d())
	enemy_node.get_parent().add_child(label)
	label.global_transform = global_trans
	if enemy_node.hp <= 0:
		enemy_node.queue_free()

func _process(delta):
	pass

func _physics_process(delta):
	pass
	

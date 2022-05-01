extends Node
class_name State

var enemy_node

func start(node):
	enemy_node = node

func bullet_hit(damage, global_trans):
	enemy_node.hp -= damage
	if enemy_node.hp <= 0:
		enemy_node.queue_free()

func _process(delta):
	pass

func dir_to_player():
	return PlayerManager.get_player_position() - enemy_node.global_transform.origin

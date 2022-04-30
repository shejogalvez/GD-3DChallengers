extends Node

var player : KinematicBody
var player_attack = 100
var player_defense = 100

func set_player(player_node):
	player = player_node
	
func get_player_position():
	return player.global_transform.origin

func set_weapon(weapon_node):
	player.set_weapon(weapon_node)

func get_weapon():
	return player.weapon

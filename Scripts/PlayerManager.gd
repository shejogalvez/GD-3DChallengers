extends Node

const PLAYER_MIN_TOTAL_HP = 1 # Min total hp
const PLAYER_MAX_TOTAL_HP = 99999 # Max total hp

const PLAYER_MIN_AKT = 0
const PLAYER_MAX_ATK = 99999

const PLAYER_MIN_DEF = 1
const PLAYER_MAX_DEF = 99999

var player : Player
var player_total_hp = 300 # Total hp
var player_hp = player_total_hp # Current hp
var player_attack = 10
var player_defense = 1

# Combat variables
const UNTARGETABLE_TIME = 1
var untargetable = false
var invulnerability_time = 0

# Called each pseudo frame.
func _process(delta):
	if invulnerability_time > 0:
		invulnerability_time -= delta
	else:
		untargetable = false

# Sets the player node
func set_player(player_node):
	player = player_node
	
# Returns the player node
func get_player():
	return player

# Sets the current player global position
func set_player_position(position):
	player.global_transform.origin = position
	
# Gets the current player global position
func get_player_position():
	if player != null:
		return player.global_transform.origin
	return Vector3.ZERO

# Sets the player weapon
func set_weapon(weapon_node):
	player.change_weapon(weapon_node)

# Gets the player weapon
func get_weapon():
	return player.weapon
	
# Sets the player current hp
func set_hp(hp):
	player_hp = clamp(hp, 0, player_total_hp)
	player.update_hp_bar()

# Gets the player current hp
func get_hp():
	return player_hp
	
# Sets the player total hp
func set_total_hp(total_hp):
	player_total_hp = clamp(total_hp, PLAYER_MIN_TOTAL_HP, PLAYER_MAX_TOTAL_HP)
	
# Gets the player total hp
func get_total_hp():
	return player_total_hp
	
# Substract the player the hp amount equivalent to the maximum
# between the 20% of the income damage and the income damage minus
# the player defense
func receive_damage(damage):
	if not untargetable:
		untargetable = true
		invulnerability_time = UNTARGETABLE_TIME
		var true_damage = ceil(max(damage * 0.2, damage - player_defense))
		set_hp(player_hp - true_damage)
		player.play_damage_audio()
	

extends Node

# Signal called when the view is changed.
signal view_changed
# Signal called when the hp changes.
signal hp_changed

const PLAYER_MIN_TOTAL_HP = 1 # Min total hp
const PLAYER_MAX_TOTAL_HP = 99999 # Max total hp

const PLAYER_MIN_AKT = 0 # Min attack
const PLAYER_MAX_ATK = 99999 # Max attack

const PLAYER_MIN_DEF = 1 # Min defense
const PLAYER_MAX_DEF = 99999 # Max defense

const PLAYER_MIN_MONEY = 0
const PLAYER_MAX_MONEY = 99999

var player : Player # Player kinematic body node
var player_total_hp = 300 # Current total hp
var player_hp = player_total_hp # Current hp
var player_attack = 10 # Current attack
var player_defense = 1 # Current defense
var player_money = 0 # Current money

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
		return player.hitbox.global_transform.origin
	return Vector3.ZERO
	
func get_player_face_position():
	if player != null:
		return player.head_camera.global_transform.origin

# Sets the player weapon
func set_weapon(weapon_node):
	player.change_weapon(weapon_node)

# Gets the player weapon
func get_weapon():
	return player.weapon
	
# Sets the player current hp
func set_hp(hp):
	player_hp = clamp(hp, 0, player_total_hp)
	emit_signal("hp_changed")

# Gets the player current hp
func get_hp():
	return player_hp
	
# Sets the player total hp
func set_total_hp(total_hp):
	player_total_hp = clamp(total_hp, PLAYER_MIN_TOTAL_HP, PLAYER_MAX_TOTAL_HP)
	set_hp(min(player_hp, player_total_hp))
	
# Gets the player total hp
func get_total_hp():
	return player_total_hp

# Adds a value to the player total hp
func add_total_hp(hp):
	set_total_hp(player_total_hp + hp)

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
	
# Adds money to the player money.
func add_money(money):
	player_money += money

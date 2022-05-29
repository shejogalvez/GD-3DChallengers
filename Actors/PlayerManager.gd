extends Node

# ========================
# Pickup inventory class
# ========================
class ConsumableInventory:
	var consumables := []
	var size := 1
	var current_consumable_index := 0
	
	# Uses the consumable in the front of the list.
	func use_consumable() -> void:
		if not consumables.empty():
			consumables[current_consumable_index].consume()
			consumables.remove(current_consumable_index)
			if consumables.size() <= current_consumable_index:
				current_consumable_index = 0
			
	# Adds a consumable to the back of the list, if list is full,
	# replaces the current consumable and throws it.
	func add_consumable(consumable : Consumable) -> void:
		if consumables.size() < size:
			consumables.insert(current_consumable_index, consumable)
			switch_consumable()
		else:
			var consumable_pickup : ConsumablePickup = consumables[current_consumable_index].pickup_scene.instance()
			PlayerManager.get_player().get_parent().add_child(consumable_pickup)
			consumable_pickup.global_transform.origin = PlayerManager.get_player_position()
			consumables[current_consumable_index].free()
			consumables[current_consumable_index] = consumable

	# Switch the current consumable.
	func switch_consumable() -> void:
		if not consumables.empty():
			current_consumable_index = (current_consumable_index + 1) % consumables.size()
		else:
			current_consumable_index = 0

	# Gets the consumable in the given index.
	func get_consumable(index : int) -> Consumable:
		if consumables.size() <= index:
			return null
		return consumables[(current_consumable_index + index) % consumables.size()]
	
# Signal called when the view is changed.
signal view_changed
# Signal called when the hp changes.
signal hp_changed
# Signal called when the attack changes.
signal attack_changed
# Signal called when the defense changes.
signal defense_changed
# Signal called when the money changes.
signal money_changed
# Signal called when consumables are updated.
signal consumables_updated

const PLAYER_MIN_TOTAL_HP := 1 # Min total hp
const PLAYER_MAX_TOTAL_HP := 99999 # Max total hp

const PLAYER_MIN_AKT := 0 # Min attack
const PLAYER_MAX_ATK := 99999 # Max attack

const PLAYER_MIN_DEF := 1 # Min defense
const PLAYER_MAX_DEF := 99999 # Max defense

const PLAYER_MIN_MONEY := 0
const PLAYER_MAX_MONEY := 99999

var player : Player # Player kinematic body node

var player_total_hp := 300 # Current total hp
var player_hp := player_total_hp # Current hp

var player_attack := 10 # Current attack
var player_defense := 1 # Current defense

var player_money := 0 # Current money
var player_money_multiplier := 1.0

# Consumables
const CONSUMABLE_INVENTORY_MAX_SIZE := 5
var consumable_inventory := ConsumableInventory.new()
var player_consumable_multiplier := 1.0

# Combat
const UNTARGETABLE_TIME := 0.2
var untargetable := false
var current_untargetable_time := 0.0


# Called each pseudo frame.
func _process(delta):
	# -----------------------------
	# Using consumable
	# -----------------------------
	if Input.is_action_just_pressed("use_consumable") and not Input.is_action_pressed("switch_consumable"):
		consumable_inventory.use_consumable()
		emit_signal("consumables_updated")
	# -----------------------------
	# Switching consumable
	# -----------------------------
	if Input.is_action_just_pressed("switch_consumable"):
		consumable_inventory.switch_consumable()
		emit_signal("consumables_updated")
	
	if current_untargetable_time > 0:
		current_untargetable_time -= delta
	else:
		untargetable = false

# Sets the player node.
func set_player(player_node : Player) -> void:
	player = player_node
	
# Returns the player node.
func get_player() -> Player:
	return player

# Sets the current player global position.
func set_player_position(position : Vector3) -> void:
	player.global_transform.origin = position
	
# Gets the current player global position.
func get_player_position() -> Vector3:
	if player != null:
		return player.hitbox.global_transform.origin
	return Vector3.ZERO
	
# Gets the player face position.
func get_player_face_position() -> Vector3:
	if player != null:
		return player.head_camera.global_transform.origin
	return Vector3.ZERO

# ========================
# Weapons
# ========================

# Sets the player weapon.
func set_weapon(weapon_node : Weapon) -> void:
	player.change_weapon(weapon_node)

# Gets the player weapon.
func get_weapon() -> Weapon:
	return player.weapon

# Sets the player a temporary weapon.
func set_temporary_weapon(temp_weapon_node : TemporaryWeapon) -> void:
	temp_weapon_node.previous_weapon = player.weapon.duplicate()
	player.change_weapon(temp_weapon_node)

# ========================
# View
# ========================
	
# Returns true if view is on head, false otherwise.
func is_head_view() -> bool:
	if is_instance_valid(player):
		return player.is_head_view
	return true

# ========================
# Health Points
# ========================

# Sets the player total hp.
func set_total_hp(total_hp : int) -> void:
	player_total_hp = clamp(total_hp, PLAYER_MIN_TOTAL_HP, PLAYER_MAX_TOTAL_HP)
	set_hp(min(player_hp, player_total_hp))
	
# Gets the player total hp.
func get_total_hp() -> int:
	return player_total_hp

# Adds a value to the player total hp.
func add_total_hp(hp : int) -> void:
	set_total_hp(player_total_hp + hp)

# Sets the player current hp.
func set_hp(hp : int) -> void:
	player_hp = clamp(hp, 0, player_total_hp)
	emit_signal("hp_changed")

# Gets the player current hp.
func get_hp() -> int:
	return player_hp
	
# Heals the player.
func heal(healing : int) -> void:
	set_hp(player_hp + healing)

# Substract the player the hp amount equivalent to the maximum
# between the 20% of the income damage and the income damage minus
# the player defense.
func receive_damage(damage : int) -> void:
	if not untargetable:
		untargetable = true
		current_untargetable_time = UNTARGETABLE_TIME
		var true_damage = ceil(max(damage * 0.2, damage - player_defense))
		set_hp(player_hp - true_damage)
		player.play_damage_audio()

# ========================
# Attack
# ========================

# Sets the player attack.
func set_attack(attack : int) -> void:
	player_attack = clamp(attack, PLAYER_MIN_AKT, PLAYER_MAX_ATK)
	emit_signal("attack_changed")

# Gets the player attack.
func get_attack() -> int:
	return player_attack
	
# Adds a value to the player attack.
func add_attack(attack : int) -> void:
	set_attack(player_attack + attack)
	
# Removes a value to the player attack.
func remove_attack(attack : int) -> void:
	set_attack(player_attack - attack)

# Adds attack temporarily.
func add_temporary_attack(attack : int, time : float) -> void:
	add_attack(attack)
	var tree_timer := get_tree().create_timer(time)
	tree_timer.connect("timeout", self, "remove_attack", [attack])

# ========================
# Defense
# ========================

# Sets the player defense.
func set_defense(defense : int) -> void:
	player_defense = clamp(defense, PLAYER_MIN_DEF, PLAYER_MAX_DEF)
	emit_signal("defense_changed")

# Gets the player defense.
func get_defense() -> int:
	return player_defense
	
# Adds a value to the player defense.
func add_defense(defense : int) -> void:
	set_defense(player_defense + defense)
	
# Removes a value to the player defense.
func remove_defense(defense : int) -> void:
	set_defense(player_defense - defense)

# Adds defense temporarily.
func add_temporary_defense(defense : int, time : float) -> void:
	add_defense(defense)
	var tree_timer := get_tree().create_timer(time)
	tree_timer.connect("timeout", self, "remove_defense", [defense])


# ========================
# Money
# ========================

# Sets the player money.
func set_money(money : int) -> void:
	player_money = clamp(money, PLAYER_MIN_MONEY, PLAYER_MAX_MONEY)
	emit_signal("money_changed")

# Gets the player money.
func get_money() -> int:
	return player_money

# Adds money to the player money.
func add_money(money : int) -> void:
	var money_added := money * player_money_multiplier
	set_money(player_money + money_added)
	
# Adds multiplier to the player money multiplier.
func add_money_multiplier(multiplier : float):
	player_money_multiplier += multiplier
	
# ========================
# Consumables
# ========================

# Gets the consumable in the given index.
func get_consumable(index : int) -> Consumable:
	return consumable_inventory.get_consumable(index)
	
# Adds a consumable to the consumable inventory.
func add_consumable(consumable : Consumable) -> void:
	consumable_inventory.add_consumable(consumable)
	emit_signal("consumables_updated")

# Returns true if the consumable inventory is empty, false otherwise.
func consumables_empty() -> bool:
	return consumable_inventory.consumables.empty()

# Gets the current size of the consumable inventory.
func get_consumables_size() -> int:
	return consumable_inventory.consumables.size()

# Adds maximum size to the consumable inventory.
func add_consumables_total_size(size : int) -> void:
	consumable_inventory.size = min(consumable_inventory.size + size, CONSUMABLE_INVENTORY_MAX_SIZE)
	
# Gets the player consumable multiplier.
func get_consumable_multiplier() -> float:
	return player_consumable_multiplier

# Adds multiplier to the player consumable multiplier.
func add_consumable_multiplier(multiplier : float) -> void:
	player_consumable_multiplier += multiplier

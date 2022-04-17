extends Spatial
class_name Weapon, "res://Assets/Classes/weapon_icon.png"

# Weapon name
export(String) var weapon_name = "Weapon"
# Weapon damage (is a factor for the player attack)
export(float, 0, 99) var damage_factor = 0
# Cooldown for fire
export(float, 0, 99) var fire_cd = 1.0
# Current cooldown for the next shot
var current_fire_cd = 0.0
# Projectile amount
export(int, 0, 10) var projectiles = 1
# Projectile scene
export(PackedScene) var projectile_scene = preload("res://Scenes/Projectiles/Projectile.tscn")

# Barrel node
onready var barrel = $Barrel 

# Called each frame
func _physics_process(delta):
	current_fire_cd -= delta

# Sets the 
func _set_projectile_transform(projectile, projectile_id):
	projectile.global_transform = barrel.global_transform

# Fires the weapon
func _fire():
	for projectile_id in projectiles:
		var projectile = projectile_scene.instance()
		var scene_root = get_tree().root.get_children()[0]
		scene_root.add_child(projectile)
		_set_projectile_transform(projectile, projectile_id)
		projectile.projectile_damage = damage_factor * Player_Manager.player_attack

# Tries to fire the weapon
func fire_weapon():
	if current_fire_cd <= 0:
		_fire()
		current_fire_cd = fire_cd
		


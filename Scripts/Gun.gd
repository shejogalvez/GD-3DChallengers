extends Spatial

const DAMAGE = 15

# Cooldown for each bullet to fire
const BULLET_CD = 0.3 
var current_bullet_cd = 0

var is_weapon_enabled = false

var bullet_scene = preload("res://Scenes/Bullet_Scene.tscn")

# Called each frame
func _physics_process(delta):
	current_bullet_cd -= delta

func fire_weapon():
	if current_bullet_cd <= 0:
		var bullet_clone = bullet_scene.instance()
		var scene_root = get_tree().root.get_children()[0]
		scene_root.add_child(bullet_clone)

		bullet_clone.global_transform = self.global_transform
		bullet_clone.translate(Vector3.BACK * 5)
		bullet_clone.scale = Vector3(4, 4, 4)
		bullet_clone.BULLET_DAMAGE = DAMAGE
		
		current_bullet_cd = BULLET_CD




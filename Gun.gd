extends Spatial

const DAMAGE = 15

var is_weapon_enabled = false

var bullet_scene = preload("Bullet_Scene.tscn")

func fire_weapon():
	var clone = bullet_scene.instance()
	var scene_root = get_tree().root.get_children()[0]
	scene_root.add_child(clone)

	clone.global_transform = self.global_transform
	clone.translate( Vector3.BACK * 5)
	clone.scale = Vector3(10,10,10)
	clone.BULLET_DAMAGE = DAMAGE



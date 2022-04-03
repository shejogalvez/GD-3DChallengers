extends Spatial

const DAMAGE = 15

var is_weapon_enabled = false

var bullet_scene = preload("Bullet_Scene.tscn")

func fire_weapon():
	var bullet_clone = bullet_scene.instance()
	var scene_root = get_tree().root.get_children()[0]
	scene_root.add_child(bullet_clone)

	bullet_clone.global_transform = self.global_transform
	bullet_clone.translate(Vector3.BACK * 5)
	bullet_clone.scale = Vector3(4, 4, 4)
	bullet_clone.BULLET_DAMAGE = DAMAGE



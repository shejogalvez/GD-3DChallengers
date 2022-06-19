extends KinematicBody
var gradient : float = 0.1
var x_offset : float = 30
var x_offset_init = 20
var z_separation : float = 50
var n_points : int = 5
var bullet_density_inverse = 1
var control_point_xoffset = 100

var animator : AnimationPlayer
var bullet_scene : PackedScene = preload("res://enemies/attack_patterns/remi_bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	animator = $AnimationPlayer
	play()

func create_rand_forward_vec2(i, local_x, local_y, origin2d, x_init, x_offset):
		var max_from_z = z_separation * gradient * i + x_offset
		var vecx = rand_range(-max_from_z, max_from_z) * local_x + x_init
		var vecy = (z_separation * i) * local_y
		return origin2d + vecx + vecy


func create_curve_path_forward() -> Curve2D:
	var patin = Curve2D.new()
	var global_trans = self.global_transform
	patin.bake_interval = bullet_density_inverse
	var local_x =  Vector2(global_trans.basis.x.x, global_trans.basis.x.z)
	var local_y = Vector2(global_trans.basis.z.x, global_trans.basis.z.z)
	var origin2d = Vector2(global_trans.origin.x, global_trans.origin.z)
	var x_init = rand_range(-x_offset_init, x_offset_init) * local_x
	var p0 : Vector2
	var p1 : Vector2
	var p2 : Vector2
	for i in range(n_points):
		p0 = create_rand_forward_vec2(i, local_x, local_y, origin2d, x_init, x_offset)
		#if i != n_points:
		p1 = create_rand_forward_vec2(0.10, local_x, local_y, Vector2.ZERO, x_init, control_point_xoffset)
		p2 = create_rand_forward_vec2(0.20, local_x, local_y, Vector2.ZERO, x_init, control_point_xoffset)
#		else:
#			p1 = Vector2.ZERO
#			p2 = Vector2.ZERO
		patin.add_point(p0, p1, p2)
	return patin

func bullet_lotus():
	var path = create_curve_path_forward()
	var attack = BulletLotus.new(path, 2, 1, self.global_transform.origin.y)
	get_parent().add_child(attack)
	

func play():
	animator.play("bullet_lotus")

extends KinematicBody

var gradient : float = 1.2
var x_offset : float = 20
var x_offset_init = 5
var z_separation : float = 100
var n_points : int = 3
var bullet_density_inverse = 1
var control_point_xoffset = 50

var animator : AnimationPlayer
var trail_bullet_scene : PackedScene = preload("res://enemies/attack_patterns/bullet_scenes/enemy_bullert.tscn")

var explosion_circle_scene = preload("res://enemies/attack_patterns/bullet_scenes/explosion_circle.tscn")
export (float) var ground_height = 12.25

# point where enemies might spawn
var circle_radius = 40
var circle_center : Vector2
var circle_center_offset = 10
var enemy_scene : PackedScene = preload( "res://enemies/sand_soldier/sand_soldier.tscn" )

var random = RandomNumberGenerator.new()
var state : RemState
onready var hp_bar = $hp_bar
var max_hp = 500
var hp = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	hp = max_hp
	self.state = RemState.phase1.new()
	state.start(self)
	
	random.randomize()
	animator = $AnimationPlayer
	var local_y = Vector2(global_transform.basis.z.x, global_transform.basis.z.z).normalized()
	var origin2d = Vector2(global_transform.origin.x, global_transform.origin.z)
	circle_center = local_y * (circle_radius + circle_center_offset) + origin2d

func create_rand_forward_vec2(i, local_x, local_y, origin2d, x_init, x_rand_val):
		var vecx = x_rand_val * local_x + x_init
		var vecy = (z_separation * i) * local_y
		return origin2d + vecx + vecy

func create_curve_path_forward() -> Curve2D:
	var patin = Curve2D.new()
	var global_trans = self.global_transform
	patin.bake_interval = bullet_density_inverse
	var local_x =  Vector2(global_trans.basis.x.x, global_trans.basis.x.z).normalized()
	var local_y = Vector2(global_trans.basis.z.x, global_trans.basis.z.z).normalized()
	var origin2d = Vector2(global_trans.origin.x, global_trans.origin.z)
	var x_init = rand_range(-x_offset_init, x_offset_init) * local_x
	var p0 : Vector2
	var p1 : Vector2
	var p2 : Vector2
	for i in range(n_points):
		p0 = create_rand_forward_vec2(i, local_x, local_y, origin2d, x_init, 0)
		var max_from_z = gradient * i * z_separation + control_point_xoffset
		p1 = create_rand_forward_vec2(0.10, local_x, local_y, Vector2.ZERO, x_init, rand_range(0.5*max_from_z, max_from_z))
		p2 = create_rand_forward_vec2(0.20, local_x, local_y, Vector2.ZERO, x_init, rand_range(-max_from_z, -0.5*max_from_z))
		patin.add_point(p0, p1, p2)
	return patin

func bullet_lotus():
	face_player()
	var path = create_curve_path_forward()
	var attack = BulletLotus.new(path, 2, 1, self.global_transform.origin.y, get_parent().global_transform.basis.get_euler().y)
	get_parent().add_child(attack)

func trail_bullet():
	var bullet = trail_bullet_scene.instance()
	get_parent().add_child(bullet)
	bullet.scale = Vector3(5,5,5)
	bullet.global_transform = self.global_transform
	bullet.set_dir_to_player((PlayerManager.get_player_position() - self.global_transform.origin).normalized())

func set_explosion():
	var bullet = explosion_circle_scene.instance()
	get_parent().add_child(bullet)
	bullet.scale = Vector3(2, 2, 2)
	bullet.global_transform.origin = PlayerManager.get_player_position()
	bullet.global_transform.origin.y = ground_height

func spawn_enemy():
	var enemy : IEnemy = enemy_scene.instance()
	enemy.alert_range = 1000
	var angle = rand_range(0, 2*PI)
	get_parent().add_child(enemy)
	enemy.global_transform.origin = Vector3(circle_center.x + circle_radius*cos(angle), ground_height, circle_center.y + circle_radius*sin(angle))

func play(animation_name):
	animator.play(animation_name)
	
func vec_to_player2d():
	var vec3d = -(self.global_transform.origin - PlayerManager.get_player_position())
	return Vector3(vec3d.x, 0, vec3d.z)
	
func face_player():
	var dir : Vector3 = vec_to_player2d()
	var angle;
	var back : Vector3 
	angle = dir.angle_to(global_transform.basis.z)
	if global_transform.basis.x.dot(dir) > 0:
		rotate_y(angle)
	else: rotate_y(-angle)

############ MOVE PATTERNS #####################


var radial_avarage = 120
var radial_variance = 8
var angle_variance = 5
var angle_avarage = 30

var margin = {UP=-10, DOWN=-250, LEFT=-120, RIGHT=120}
var to_go_position := Vector3.ZERO
var vec_from_player : Vector3
var lerp_weight = 0.1
var max_speed = 55

var phase2_position = Vector3(0, 55, -40)

# sets a point to move based on self and player position
func get_next_step():
	vec_from_player = -(PlayerManager.get_player_position() - self.global_transform.origin).normalized()
	var player_pos2d = Vector2(PlayerManager.get_player_position().x, PlayerManager.get_player_position().z)
	var vec2d = Vector2(vec_from_player.x, vec_from_player.z)
	var new_radius = random.randfn(radial_avarage, radial_variance)
	var angle = random.randfn(angle_avarage, angle_variance)
	if random.randf() > 0.5:
		angle = -angle
	var to_go2d = vec2d.rotated(deg2rad(angle)) * new_radius + player_pos2d
	var room_origin := Vector2.ZERO 
	if get_parent_spatial() != null:
		room_origin = Vector2(get_parent_spatial().global_transform.origin.x, get_parent_spatial().global_transform.origin.z)
	to_go2d.x = clamp(to_go2d.x, room_origin.x + margin.LEFT,  room_origin.x + margin.RIGHT)
	to_go2d.y = clamp(to_go2d.y, room_origin.y + margin.DOWN, room_origin.y + margin.UP)
	to_go_position = Vector3(to_go2d.x, self.global_transform.origin.y, to_go2d.y)
	#print(PlayerManager.get_player_position(), to_go_position, "  angle= %d,  radius= %d " % [angle, new_radius])
	return to_go_position

func set_room_size(size : float):
	margin.UP = size
	margin.DOWN = -size
	margin.LEFT = -size
	margin.RIGHT = size

func set_initial_pos(real_pos : Vector3):
	global_translate(real_pos + Vector3.UP * 30)
	to_go_position = real_pos + get_parent_spatial().global_transform.origin

func physics_process_phase1(delta):
	var dif_vector = to_go_position - global_transform.origin
	var jump_candidate : Vector3 = lerp(Vector3.ZERO, to_go_position - global_transform.origin, lerp_weight)
	if jump_candidate.length() > max_speed * delta: 
		global_translate(dif_vector.normalized() * max_speed * delta)
	else:
		global_translate(jump_candidate)

func start_phase2():
	to_go_position = phase2_position + get_parent_spatial().global_transform.origin

func set_state(newstate : RemState):
	self.state = newstate
	newstate.start(self)

func projectile_hit(damage, trans):
	state.projectile_hit(damage)

func _process(delta):
	state._process(delta)
	pass

func _physics_process(delta):
	state._physics_process(delta)

class RemState:
	var boss_node
	
	func projectile_hit(damage):
		pass
	
	func start(node):
		boss_node = node
		#textures = boss_node.textures
		
	func _process(delta):
		pass
	
	func _physics_process(delta):
		boss_node.physics_process_phase1(delta)

	class wait extends RemState:
		pass

	class phase1 extends RemState:
		const cd = 7
		var timer = 4.5


		func projectile_hit(damage):
			boss_node.hp -= damage
			boss_node.hp_bar.update_hp(boss_node.hp)
			if boss_node.hp <= 0:
				boss_node.hp = boss_node.max_hp
				boss_node.set_state(phase2.new())


		func _process(delta):
			if timer > cd:
				if randf() > 0.5:
					boss_node.get_next_step()
					boss_node.play("trail_bullet")
					timer = 0
				else:
					boss_node.play("bullet_lotus")
					timer = -2
			timer += delta

	class phase2 extends RemState:
		
		const spawn_cd = 3.5
		var spawn_index = 1
		const explosion_cd = 5.5
		var explosion_index = 1
		var timer = 0
		
		func projectile_hit(damage):
			boss_node.hp -= damage*0.75
			boss_node.hp_bar.update_hp(boss_node.hp)
			if boss_node.hp <= 0:
				if GameManager.current_level != null:
					GameManager.clear_level()
				boss_node.queue_free()
		
		func _ready():
			boss_node.start_phase2()
			
		func _process(delta):
			if timer > spawn_cd * spawn_index:
				boss_node.play("spawn")
				spawn_index+=1
			if timer > explosion_cd * explosion_index:
				boss_node.play("explosion")
				explosion_index+=1
			boss_node.face_player()
			timer += delta
		
		func _physics_process(delta):
			._physics_process(delta)
			boss_node.to_go_position = boss_node.phase2_position + boss_node.get_parent_spatial().global_transform.origin

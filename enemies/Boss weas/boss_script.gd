extends KinematicBody
class_name BossTest
var hp = 500

onready var lhand = $l_hand
onready var rhand = $r_hand
onready var hp_bar = $hp_bar
onready var pivot = $pivot
onready var face = $face
var hapi : Material
var angri : Material
var mode : Mode
var frenzy_count = 0
const INTRO_TIMER = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_mode(Mode.IntroMode.new())
	hapi = face.get_active_material(0)
	angri = hapi.next_pass


func bullet_hit(damage, transform):
	mode.bullet_hit(damage)
		
func set_mode(mode):
	self.mode = mode
	self.mode.start(self)
		

func _process(delta):
	mode._process(delta)
		
# object behavior indicated by status machine
class Mode:
	var boss_node : BossTest
	var lhand 
	var rhand 
	var pivot :Position3D
	
	const frenzy_marks = [400, 200, -1] 
	
	func bullet_hit(damage):
		boss_node.hp -= damage
		boss_node.hp_bar.update_hp(boss_node.hp)
		if boss_node.hp <= 0:
			boss_node.queue_free()
	
	func start(node):
		boss_node = node
		lhand = boss_node.lhand
		rhand = boss_node.rhand
		pivot = boss_node.pivot
		#textures = boss_node.textures
		
	func _process(delta):
		pass
		
	class IntroMode extends Mode:
		
		var time = 0
		func _process(delta):
			if time >= INTRO_TIMER:
				boss_node.set_mode(Mode.NormalMode.new())
			time += delta
			
		func bullet_hit(damage):
			pass
	
	class NormalMode extends Mode:
		
		func start(node):
			.start(node)
			boss_node.face.set_surface_material(0, boss_node.hapi)
		
		func _process(delta):
			lhand.fire_weapon()
			rhand.fire_weapon()
		
		func bullet_hit(damage):
			.bullet_hit(damage)
			if boss_node.hp <= frenzy_marks[boss_node.frenzy_count]:
				boss_node.set_mode(Mode.FrenzyMode.new())
			
	
	class FrenzyMode extends Mode:
		var accel = 0.5
		const TIME_MAX = 4*PI
		var time_elapsed = 0
		var pos = 0
		
		func smooth_angle(target_pos, delta):
			var displace = (target_pos - pos) * accel * delta
			pos += displace
			return displace
			
		func rotateAround(obj, point, axis, angle):#wachipiteada
			var rot = angle + obj.rotation.y 
			var tStart = point
			obj.global_translate (-tStart)
			obj.transform = obj.transform.rotated(axis, -rot)
			obj.global_translate (tStart)
			
		func start(node):
			.start(node)
			lhand.fire_cd = 0.5
			rhand.fire_cd = 1.2
			boss_node.face.set_surface_material(0, boss_node.angri)
		
		func _process(delta):
			if time_elapsed < TIME_MAX:
				time_elapsed += delta
				lhand.fire_weapon()
				rhand.fire_weapon()
				
				var displace = smooth_angle(time_elapsed, delta*1.5) 
				self.rotateAround(boss_node, pivot.global_transform.origin , Vector3.UP, pos)
				
			elif time_elapsed - pos > 0.001:
				var displace = smooth_angle(time_elapsed, delta) 
				self.rotateAround(boss_node, pivot.global_transform.origin, Vector3.UP, pos)
			
			else:
				lhand.fire_cd = boss_node.lhand.ATTACK_CD
				rhand.fire_cd = boss_node.rhand.ATTACK_CD
				boss_node.set_mode(Mode.NormalMode.new())
				boss_node.frenzy_count += 1
		
	

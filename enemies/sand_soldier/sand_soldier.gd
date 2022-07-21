extends IEnemy

onready var animator : AnimationPlayer = $AnimationPlayer
onready var collider = $CollisionShape
onready var weapon = $weapon
onready var weapon_area = $weapon/spearV20/Area

export (Curve) var dash_curve
var hit_player = false
const damage = 15

func _ready():
	standbyState = Initial.new()
	alertedState = Follow.new()
	set_state(standbyState)
	hp = 0
	weapon_area.connect("body_entered", self, "weapon_hit")

func awake():
	set_state(alertedState)
	weapon.visible = true
	collider.disabled = false
	hit_player = false
	
func found_player():
	set_state(WaitS.new())
	animator.play("emerge")
	
func set_dash():
	set_state(Attacking.new())
	state.direction = vec_to_player2d()

func dash():
	state.dashin = true
	
func weapon_hit(body):
	if hit_player == false:
		if body == PlayerManager.get_player():
			PlayerManager.receive_damage(damage)
			hit_player = true

class WaitS extends Wait:
	func _process(delta):
		if enemy_node.weapon.visible:
			enemy_node.set_state(enemy_node.alertedState)

class Initial extends Standby:
	func projectile_hit(damage, global_trans):
		pass

class Follow extends State:
	
	var dif_vec : Vector3
	var vel = Vector3.ZERO
	const GRAVITY = -80
	const MAX_SLOPE_ANGLE = 40
	const SPEED = 10
	const ACCEL = 20
	var actual_speed = 0
	const ATTACK_DISTANCE = 30
	const LOSE_DISTANCE = 150
	
	func _physics_process(delta):
		var direction : Vector3 = enemy_node.vec_to_player().normalized()
		actual_speed = min(actual_speed + ACCEL*delta, SPEED)
		vel.x = direction.x*actual_speed
		vel.z = direction.z*actual_speed
		
		vel.y += GRAVITY * delta
		vel = enemy_node.move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))
		
	func _process(delta):
		if not alerted:
			var dif = enemy_node.global_transform.origin - PlayerManager.get_player_position()
			if dif.length() < ATTACK_DISTANCE:
				enemy_node.animator.queue("attack")
				alerted = true
			if dif.length() >  LOSE_DISTANCE:
				enemy_node.animator.play_backwards("emerge")
				enemy_node.set_state(enemy_node.standbyState)
		enemy_node.face_player()
		
	func projectile_hit(damage, trans):
		.projectile_hit(damage, trans)
		actual_speed = 0
		
class Attacking extends State:
	
	const DASH_SPEEDMAX = 25
	var dashin = false
	var direction : Vector3
	var time = 0
	var animation_time = 0.75
	
	func _physics_process(delta):
		if (dashin):
			var dash = enemy_node.dash_curve.interpolate_baked(time/animation_time) * DASH_SPEEDMAX
			dash = enemy_node.move_and_slide(dash * direction, Vector3(0, 1, 0))
			time += delta
			if (time > animation_time): dashin = false

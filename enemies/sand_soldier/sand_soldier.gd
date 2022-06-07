extends IEnemy

onready var animator = $AnimationPlayer
onready var collider = $CollisionShape
onready var weapon = $weapon
onready var weapon_area = $weapon/spearV20/Area

export (Curve) var dash_curve
var hit_player = false
const damage = 15

func _ready():
	._ready()
	hp = 0
	weapon_area.connect("body_entered", self, "weapon_hit")

func awake():
	self.state = Follow.new()
	state.start(self)
	weapon.visible = true
	hit_player = false
	
func found_player():
	set_state(Wait.new())
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
	

class Follow extends State:
	
	var dif_vec : Vector3
	var vel = Vector3.ZERO
	const GRAVITY = -80
	const MAX_SLOPE_ANGLE = 40
	const SPEED = 10
	const ATTACK_DISTANCE = 30
	
	func _physics_process(delta):
		var direction : Vector3 = enemy_node.vec_to_player().normalized()
		vel.x = direction.x*SPEED
		vel.z = direction.z*SPEED
		
		vel.y += GRAVITY * delta
		vel = enemy_node.move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))
		
	func _process(delta):
		if not alerted:
			var dif = enemy_node.global_transform.origin - PlayerManager.get_player_position()
			if dif.length() < ATTACK_DISTANCE:
				enemy_node.animator.queue("attack")
				alerted = true
		enemy_node.face_player()
		
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

extends KinematicBody

const SPEED = 20 
const PUSH_UP = 10
const PUSH_BACK_SPEED = 10
const CC_BULLET_TIME = 0.5
const CC_ATACK_TIME = 1.2
const MAX_SLOPE_ANGLE = 40
const GRAVITY = -80
const ALERT_DISTANCE = 40
const HIT_DISTANCE = 6

var direction : Vector3
var vel : Vector3

var hp = 70
var alerted = false
var stun_timer = 0

	
func _physics_process(delta):
	var distance_player = self.global_transform.origin - Player_Manager.get_player_position()
	
	if distance_player.length() < ALERT_DISTANCE:
		alerted = true
		
	if stun_timer > 0:
		stun_timer -= delta
		
	elif distance_player.length() < HIT_DISTANCE: # player is attacked, enemy gets pushed back
		stun_timer = CC_ATACK_TIME
		vel = -vel.normalized() * PUSH_BACK_SPEED
		vel.y = PUSH_UP*CC_ATACK_TIME
		print('recieved damage')
		
	elif alerted == true: # chases player
		direction = -distance_player.normalized()
		vel.x = direction.x*SPEED
		vel.z = direction.z*SPEED
	
	vel.y += GRAVITY * delta
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))
		
		
func bullet_hit(damage, bullet_global_trans):
	alerted = true
	# gets pushed_back a little
	var direction_bullet = self.global_transform.origin - bullet_global_trans.origin
	vel.x = direction_bullet.x
	vel.z = direction_bullet.z
	vel.y = 0
	vel = vel.normalized()
	hp -= damage
	stun_timer = CC_BULLET_TIME
	vel.y = PUSH_UP*CC_BULLET_TIME
	if hp<=0:
		self.queue_free()

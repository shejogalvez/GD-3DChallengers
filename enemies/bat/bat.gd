extends IEnemy

onready var bat_attack = $Hitbox/pivot_cara/body/pivot/sound_wave
onready var face = $Hitbox/pivot_cara/body
onready var animator = $AnimationPlayer

const slow_in_attack = 0.1
var attacking = false
var initial_speed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	animator.play("idle")
	animator.connect("animation_finished", self, "back_to_idle")
	attack_distance = 15
	initial_speed = speed
	pass # Replace with function body.

func look_up_face():
	var dir : Vector3 = vec_to_player_face(self.face)
	var angle;
	if dir.y > 0:
		angle = Vector3(dir.x, 0, dir.z).angle_to(dir)
	else:
		angle = -Vector3(dir.x, 0, dir.z).angle_to(dir)
	#print(angle)
	face.rotation.x = angle
	
func attack():
	look_up_face()
	attacking = true
	self.speed *= slow_in_attack
	animator.play("attack")
	bat_attack.excecute()

func back_to_idle(body):
	face_player()
	attacking = false
	animator.play("idle")
	self.speed = initial_speed
	self.state.alerted = false
	
#func _physics_process(delta):
#	if not attacking:
#		face_player()


extends IEnemy

onready var bat_attack = $Hitbox/pivot_cara/body/pivot/sound_wave
onready var face = $Hitbox/pivot_cara/body
onready var animator = $AnimationPlayer

const slow_in_attack = 0.6

# Called when the node enters the scene tree for the first time.
func _ready():
	animator.play("idle")
	animator.connect("animation_finished", self, "back_to_idle")
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
	self.speed *= slow_in_attack
	animator.play("attack")
	bat_attack.excecute()

func back_to_idle(body):
	animator.play("idle")
	self.speed *= (1/slow_in_attack)
	self.state.alerted = false

extends IEnemy

onready var bat_attack = $Hitbox/pivot_cara/body/pivot/sound_wave
onready var face = $Hitbox/pivot_cara/body
onready var animator = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	animator.play("idle")
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
	bat_attack.excecute()


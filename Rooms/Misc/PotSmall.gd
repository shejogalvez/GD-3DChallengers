extends Spatial

onready var model = $Model
onready var collision_shape = $CollisionShape
onready var break_audio = $BreakAudio

# Called when the node enters the scene tree for the first time.
func _ready():
	break_audio.connect("finished", self, "queue_free")

# Called when the node enters the scene tree for the first time.
func projectile_hit(damage, bullet_global_trans):
	#collision_shape.queue_free()
	#if not break_audio.playing:
	#	break_audio.play()
	#var small_pot_b = small_pot_b_scene.instance()
	#get_tree().root.add_child(small_pot_b)
	#small_pot_b.global_transform = self.global_transform
	#small_pot_b.scale = model.scale
	#model.queue_free()
	$Destruction.destroy()

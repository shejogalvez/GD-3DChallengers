extends Spatial
class_name particle_trail

var ttl : float = 0
var particle_ttl : float = 0.1
var particle_length : float = 1
var timer : float = 0
var particles : CPUParticles

func _ready():
	particles = $CPUParticles
	particles.lifetime = particle_ttl
	particles.emitting = true
	particles.mesh.size = Vector3(1, 1, particle_length)

func set_ttl(offset1, offset2):
	self.ttl = offset1 + offset2
	particle_ttl = offset1
	particle_length = 16 / offset1

func _process(delta):
	if timer > ttl:
		self.queue_free()
	timer += delta

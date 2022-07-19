extends Spatial

onready var area = $pivot/CSGCombiner/Area
onready var end_shape = $pivot/CSGCombiner/end_shape
onready var collsion = $pivot/CSGCombiner/Area/CollisionShape
onready var animator = $AnimationPlayer

var hit_something = false
export (int) var damage = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	area.connect("body_entered", self, "impact")

func impact(body: Node) -> void:
	#print(body)
	if hit_something == false:
		if body == PlayerManager.get_player():
			PlayerManager.receive_damage(damage)
	hit_something = true
	animator.stop()
	reset()

func reset() -> void:
	area.scale.y = 0.01
	collsion.disabled = true
	hit_something = false
	end_shape.translation = Vector3(0, -6.3, 0)
	
func excecute() -> void:
	animator.play("excecute")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

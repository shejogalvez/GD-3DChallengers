extends Spatial

onready var area = $pivot/CSGCombiner/Area
onready var end_shape = $pivot/CSGCombiner/end_shape
onready var collsion = $pivot/CSGCombiner/Area/CollisionShape
onready var animator = $AnimationPlayer

var hit_something = false
export (int) var damage = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	area.connect("area_entered", self, "hit")

func impact(body: Node) -> void:
	if hit_something == false:
		if body == PlayerManager.get_player():
			PlayerManager.receive_damage(damage)
			queue_free()
	hit_something = true

func reset() -> void:
	area.scale.y = 0.01
	end_shape.translation.y = -2
	collsion.disabled = true
	
func excecute() -> void:
	animator.play("excecute")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

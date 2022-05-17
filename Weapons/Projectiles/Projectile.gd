extends Spatial
class_name Projectile, "res://Assets/Classes/projectile_icon.png"

# Projectile speed
export(int) var projectile_speed = 160
# Projectile damage (calculated as weapon_factor * player_attack)
var projectile_damage := 1
# Duration in seconds of the projectile
export(float) var kill_timer := 5.0
# Current projectile life in seconds
var timer := 0.0
# Boolean set to true when projectile hits something
var hit_something := false

onready var area : Area = $Area

# Called when the node enters the scene tree for the first time.
func _ready():
	area.connect("body_entered", self, "impact")

# Called each frame.
func _physics_process(delta):
	_move_projectile(delta)
	timer += delta
	if timer >= kill_timer:
		queue_free()

# Moves the projectile.
func _move_projectile(delta : float) -> void:
	var forward_dir = global_transform.basis.z.normalized()
	global_translate(forward_dir * projectile_speed * delta)

# Impacts the projectile.
func impact(body : Node) -> void:
	if hit_something == false:
		if body.has_method("projectile_hit"):
			body.projectile_hit(projectile_damage, global_transform)
	hit_something = true
	queue_free()



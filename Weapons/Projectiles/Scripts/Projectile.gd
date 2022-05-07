extends Spatial
class_name Projectile, "res://Assets/Classes/projectile_icon.png"

# Projectile speed
export var projectile_speed = 160
# Projectile damage (calculated as weapon_factor * player_attack)
var projectile_damage = 1
# Duration in seconds of the projectile
export var kill_timer = 5
# Current projectile life in seconds
var timer = 0
# Boolean set to true when projectile hits something
var hit_something = false

func _ready():
	$Area.connect("body_entered", self, "impact")

func _move_projectile(delta):
	var forward_dir = global_transform.basis.z.normalized()
	global_translate(forward_dir * projectile_speed * delta)

func _physics_process(delta):
	_move_projectile(delta)
	
	timer += delta
	if timer >= kill_timer:
		queue_free()

func impact(body):
	if hit_something == false:
		if body.has_method("bullet_hit"):
			body.bullet_hit(projectile_damage, global_transform)

	hit_something = true
	queue_free()



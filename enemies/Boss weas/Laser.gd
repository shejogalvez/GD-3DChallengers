extends Spatial

var raycast : RayCast
var lazer_mask : CSGBox
var lazer_body : CSGCylinder

export var explotion_time = 2
export var time_active = 0.5
export var damage = 10

var time = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	raycast = $Pivot/RayCast
	lazer_mask = $Pivot/CSGCombiner/CSGBox
	lazer_body = $Pivot/CSGCombiner/CSGCylinder

func _process(delta):
	time += delta
	if time > explotion_time:
		raycast.enabled = true
		lazer_body.radius = (0.5 + 0.25 * sin(10* time))
		lazer_body.material.emission_energy = 10
		lazer_body.material.albedo_color.a8 = 255
		if time > explotion_time + time_active:
			queue_free()
		
		var object = raycast.get_collider()
		var hitpoint = raycast.get_collision_point()
		
		if object!=null:
			if object.has_method("recieve_damage"):
				object.recieve_damage(damage)

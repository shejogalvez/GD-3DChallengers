extends Spatial

export var ads_lerp = 20
export var default_position : Vector3
export var ads_position : Vector3
export var default_fov : int = 90
export var ads_fov : int = 60

onready var camera : Camera = $Camera
onready var weapon_pivot : Spatial = $WeaponPivot

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("aim_down_sights"):
		weapon_pivot.transform.origin = weapon_pivot.transform.origin.linear_interpolate(ads_position, ads_lerp * delta)
		camera.fov = lerp(camera.fov, ads_fov, ads_lerp * delta)
	else:
		weapon_pivot.transform.origin = weapon_pivot.transform.origin.linear_interpolate(default_position, ads_lerp * delta)
		camera.fov = lerp(camera.fov, default_fov, ads_lerp * delta)
		

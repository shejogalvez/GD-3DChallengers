extends Spatial

export(Vector3) var closed_dynamic_door_pos = Vector3(0, 0, 0)
export(Vector3) var open_dynamic_door_pos = Vector3(0, 18, 0)

const DYNAMIC_DOOR_OPENING_SPEED = 1.5
var dynamic_door_opening := false

onready var door_single_dynamic := $DoorSingleDynamic
onready var door_single_dynamic_body := $DoorSingleDynamic/DoorSingleDynamicBody
onready var door_single_dynamic_area := $DoorSingleDynamic/Area

onready var earth_poster := $Hall/EarthPoster
onready var earth_poster_viewport := $Hall/EarthPoster/Viewport

onready var animation_player := $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	earth_poster.mesh.surface_get_material(0).albedo_texture = earth_poster_viewport.get_texture()
	door_single_dynamic_area.connect("body_entered", self, "_open_door_single_dynamic_body")
	door_single_dynamic_area.connect("body_exited", self, "_close_door_single_dynamic_body")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if dynamic_door_opening:
		door_single_dynamic_body.transform.origin = door_single_dynamic_body.transform.origin.linear_interpolate(open_dynamic_door_pos, DYNAMIC_DOOR_OPENING_SPEED * _delta)
	else:
		door_single_dynamic_body.transform.origin = door_single_dynamic_body.transform.origin.linear_interpolate(closed_dynamic_door_pos, DYNAMIC_DOOR_OPENING_SPEED * _delta)

# Opens the dynamic single door body.
func _open_door_single_dynamic_body(_body : KinematicBody) -> void:
	dynamic_door_opening = true

# Closes the dynamic single door body.
func _close_door_single_dynamic_body(_body : KinematicBody) -> void:
	dynamic_door_opening = false

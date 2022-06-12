extends Spatial

onready var earth_poster := $EarthPoster
onready var earth_poster_viewport := $EarthPoster/Viewport

# Called when the node enters the scene tree for the first time.
func _ready():
	earth_poster.mesh.surface_get_material(0).albedo_texture = earth_poster_viewport.get_texture()
	

extends Spatial
class_name Teleport, "res://Assets/Classes/teleport_icon.png"

export var teleport_position : Vector3
export var teleport_relative_position : Vector3

onready var teleport_area : Area = $TeleportArea

# Called when the node enters the scene tree for the first time.
func _ready():
	teleport_area.connect("body_entered", self, "teleport")

func set_teleport_position(position):
	teleport_position = position
	
func get_teleport_position():
	return teleport_position

func set_teleport_relative_position(direction):
	teleport_relative_position = direction

func teleport(body):
	if body == PlayerManager.get_player():
		print(self.global_transform.origin, self.teleport_relative_position)
		PlayerManager.set_player_position(self.global_transform.origin + teleport_relative_position)

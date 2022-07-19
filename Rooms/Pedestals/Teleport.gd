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
		PlayerManager.set_player_position(self.global_transform.origin + teleport_relative_position)
		var player_pos2 = Vector2(PlayerManager.get_player_position().x, PlayerManager.get_player_position().z)
		var room_pos = (GameManager.current_level.actual_pos) * GameManager.current_level.real_separation
		var new_pos_approx = Vector2(player_pos2.x - room_pos.x, player_pos2.y - room_pos.y)
		var newpos = Vector2(round(new_pos_approx.x/GameManager.current_level.real_separation), round(new_pos_approx.y/GameManager.current_level.real_separation))
		GameManager.current_level.center_minimap_in(GameManager.current_level.actual_pos + newpos)

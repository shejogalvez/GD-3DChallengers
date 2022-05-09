extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$PickupAudio.connect("finished", self, "queue_free")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("shot_main"):
		if (global_transform.origin - PlayerManager.get_player_position()).length() < 10:
			$Model.queue_free() # bugged null instance
			if not $PickupAudio.playing:
				$PickupAudio.play()

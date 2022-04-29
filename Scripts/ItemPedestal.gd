extends Spatial
class_name ItemPedestal, "res://Assets/Classes/weapon_pedestal_icon.png"

export(PackedScene) var item_scene = preload("res://Scenes/Items/Item.tscn")
var item_instance =  item_scene.instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	item_instance = item_scene.instance()
	$Item/Model.mesh = item_instance.get_node("Model").mesh
	$Item/Model.scale = Vector3(1.6, 1.6, 1.6)
	$Item/AnimationPlayer.play("float")
	$Item/Details/Panel/Name.text = item_instance.item_name
	$Item/Details/Panel/Effect.text = item_instance.item_effect
	$Item/Details/Panel/Description.text = item_instance.item_description
	$Item/Details.hide()
	$Item/PickupArea.connect("body_entered", self, "give_item")
	$Item/DetailsArea.connect("body_entered", self, "show_details")
	$Item/DetailsArea.connect("body_exited", self, "hide_details")
	$ItemPedestalAudio.connect("finished", self, "remove_audio")

# Gives the Item if area touched by a player.
func give_item(body):
	if body == Player_Manager.player:
		item_instance.use()
		$ItemPedestalAudio.play()
		$Item.queue_free()

# Shows the Item details.
func show_details(body):
	if body == Player_Manager.player:
		$Item/Details.show()

# Hides the Item details.
func hide_details(body):
	if body == Player_Manager.player:
		$Item/Details.hide()
		
# Removes the audioplayer node.
func remove_audio():
	$ItemPedestalAudio.queue_free()

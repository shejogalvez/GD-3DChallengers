extends Spatial
class_name ItemPedestal, "res://Assets/Classes/weapon_pedestal_icon.png"

export(PackedScene) var item_scene = preload("res://Scenes/Items/Item.tscn")
var item_instance =  item_scene.instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	item_instance = item_scene.instance()
	$Item/Model.set_surface_material(0, create_image_material(item_instance.item_image))
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
	if body == PlayerManager.get_player():
		item_instance.use()
		$ItemPedestalAudio.play()
		$Item.queue_free()

# Shows the Item details.
func show_details(body):
	if body == PlayerManager.get_player():
		$Item/Details.show()

# Hides the Item details.
func hide_details(body):
	if body == PlayerManager.get_player():
		$Item/Details.hide()
		
# Removes the audioplayer node.
func remove_audio():
	$ItemPedestalAudio.queue_free()

# Creates a surface material with image texture propierties
func create_image_material(image : StreamTexture) -> SpatialMaterial:
	var material = SpatialMaterial.new()
	# Always looks towards the camera
	material.params_billboard_mode = SpatialMaterial.BILLBOARD_ENABLED
	material.params_billboard_keep_scale = true
	material.params_grow = true
	material.params_grow_amount = 1
	# Enable transparent color rendering
	material.flags_transparent = true
	# Sets the texture to be the image
	material.albedo_texture = image
	return material

extends Spatial
class_name ItemPedestal, "res://Assets/Classes/pedestal_icon.png"

export(PackedScene) var item_scene = preload("res://Items/Item.tscn")

var item_instance : Item

const SPRITE_WIDTH = 640
const SPRITE_HEIGHT = 640

onready var item = $Item
onready var item_model = $Item/Model
onready var item_sprite_viewport = $Item/Model/SpriteViewport
onready var item_sprite = $Item/Model/SpriteViewport/Sprite
onready var item_pickup_area = $Item/PickupArea
onready var item_animation_player= $Item/AnimationPlayer
onready var item_details_area = $Item/DetailsArea
onready var item_details = $Item/DetailsModel/DetailsViewport/Details
onready var item_details_name = $Item/DetailsModel/DetailsViewport/Details/Panel/Name
onready var item_details_effect = $Item/DetailsModel/DetailsViewport/Details/Panel/Effect
onready var item_details_description = $Item/DetailsModel/DetailsViewport/Details/Panel/Description
onready var item_details_sprite = $Item/DetailsModel/DetailsViewport/Details/Panel/Sprite
onready var item_pedestal_audio = $ItemPedestalAudio

# Called when the node enters the scene tree for the first time.
func _ready():
	$Item/DetailsModel.mesh = QuadMesh.new()
	var material = SpatialMaterial.new()
	# Enable transparent color rendering
	material.flags_transparent = true
	
	material.params_billboard_mode = SpatialMaterial.BILLBOARD_ENABLED
	
	# Sets the texture to be the image 
	material.albedo_texture = $Item/DetailsModel/DetailsViewport.get_texture()
	$Item/DetailsModel.set_surface_material(0, material)
	$Item/DetailsModel.mesh.set_size(Vector2(4, 4))
	
	item_instance = item_scene.instance()
	item_model.mesh = QuadMesh.new()
	item_model.set_surface_material(0, create_image_material(item_instance.item_image))
	item_animation_player.play("float")
	item_details_name.text = item_instance.item_name
	item_details_effect.text = item_instance.item_effect
	item_details_description.text = item_instance.item_description
	item_details_sprite.texture = item_instance.item_image
	$Item/DetailsModel.hide()
	item_pickup_area.connect("body_entered", self, "give_item")
	item_details_area.connect("body_entered", self, "show_details")
	item_details_area.connect("body_exited", self, "hide_details")
	item_pedestal_audio.connect("finished", item_pedestal_audio, "queue_free")
	item.add_child(item_instance)

# Gives the Item if area touched by a player.
func give_item(body) -> void:
	item_instance.use()
	item_pedestal_audio.play()
	item.queue_free()
	
# Shows the item details.
func show_details(body) -> void:
	$Item/DetailsModel.show()
	
# Hides the item details.
func hide_details(body) -> void:
	$Item/DetailsModel.hide()

# Creates a surface material with image texture propierties.
func create_image_material(image : StreamTexture) -> SpatialMaterial:
	var material = SpatialMaterial.new()
	# Always looks towards the camera
	material.params_billboard_mode = SpatialMaterial.BILLBOARD_ENABLED
	# Enable transparent color rendering
	material.flags_transparent = true
	# Sets the texture to be the image 
	item_sprite.texture = image
	var width_factor = SPRITE_WIDTH / image.get_width()
	var height_factor = SPRITE_HEIGHT / image.get_height()
	item_model.mesh.set_size(Vector2(width_factor, height_factor))
	material.albedo_texture = item_sprite_viewport.get_texture()
	return material

extends Spatial
class_name ItemPedestal, "res://Assets/Classes/pedestal_icon.png"

export(PackedScene) var SmallChest_scene : PackedScene
export(PackedScene) var RubyRing_scene : PackedScene
export(PackedScene) var LeatherBackpack_scene : PackedScene
export(PackedScene) var gloves = preload("res://Items/IronGloves.tscn")
export(PackedScene) var helmet = preload("res://Items/IronHelmet.tscn")
export(PackedScene) var chestplate = preload("res://Items/IronChestplate.tscn")

var rng := RandomNumberGenerator.new()

var items_pool := []

var item_instance : Item

const SPRITE_WIDTH := 640
const SPRITE_HEIGHT := 640

onready var item = $Item
onready var item_model = $Item/ItemModel
onready var item_sprite_viewport = $Item/ItemModel/SpriteViewport
onready var item_sprite = $Item/ItemModel/SpriteViewport/Sprite
onready var item_pickup_area = $Item/PickupArea
onready var item_animation_player= $Item/ItemAnimationPlayer
onready var item_details_area = $Item/DetailsArea
onready var item_details_model = $Item/DetailsModel
onready var item_details_viewport = $Item/DetailsModel/DetailsViewport
onready var item_details_sprite = $Item/DetailsModel/DetailsViewport/DetailsPanel/DetailsSprite
onready var item_details_name = $Item/DetailsModel/DetailsViewport/DetailsPanel/DetailsHeader/DetailsName
onready var item_details_description = $Item/DetailsModel/DetailsViewport/DetailsPanel/DetailsHeader/DetailsDescription
onready var item_details_effect = $Item/DetailsModel/DetailsViewport/DetailsPanel/DetailsEffect
onready var item_details_animation_player = $Item/DetailsAnimationPlayer
onready var item_pedestal_audio = $ItemPedestalAudio

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	items_pool = [gloves, helmet, chestplate]
	item_instance = items_pool[rng.randi_range(0, items_pool.size() - 1)].instance()
	_initialize_item_model(item_instance.item_image)
	item_pickup_area.connect("body_entered", self, "_use_item")
	item_details_area.connect("body_entered", self, "_show_details")
	item_details_area.connect("body_exited", self, "_hide_details")
	_initialize_details_model()
	item_details_sprite.texture = item_instance.item_image
	item_details_name.text = item_instance.item_name
	item_details_description.text = item_instance.item_description
	item_details_effect.text = item_instance.item_effect
	item_details_model.hide()
	item_pedestal_audio.connect("finished", item_pedestal_audio, "queue_free")
	item.add_child(item_instance)

# Gives the Item if area touched by a player.
func _use_item(_body) -> void:
	item_details_animation_player.play("RESET")
	item_instance.use()
	item_pedestal_audio.play()
	item.queue_free()
	
# Shows the item details.
func _show_details(_body) -> void:
	item_details_animation_player.play("details_appear")
	
# Hides the item details.
func _hide_details(_body) -> void:
	item_details_animation_player.play("details_disappear")

# Initializes the item model.
func _initialize_item_model(image : StreamTexture) -> void:
	var material := SpatialMaterial.new()
	# Always looks towards the camera
	material.params_billboard_mode = SpatialMaterial.BILLBOARD_ENABLED
	# Enables transparent color rendering
	material.flags_transparent = true
	# Sets the texture to be the image 
	item_sprite.texture = image
	var width_factor = SPRITE_WIDTH / image.get_width()
	var height_factor = SPRITE_HEIGHT / image.get_height()
	item_model.mesh = QuadMesh.new()
	item_model.mesh.set_size(Vector2(width_factor, height_factor))
	material.albedo_texture = item_sprite_viewport.get_texture()
	item_model.set_surface_material(0, material)

# Initializes the details model.
func _initialize_details_model() -> void:
	var material := SpatialMaterial.new()
	# Render in both sides
	material.params_cull_mode = SpatialMaterial.CULL_DISABLED
	# Enable transparent color rendering
	material.flags_transparent = true
	item_details_model.mesh = QuadMesh.new()
	item_details_model.mesh.set_size(Vector2(9, 6))
	material.albedo_texture = item_details_viewport.get_texture()
	item_details_model.set_surface_material(0, material)

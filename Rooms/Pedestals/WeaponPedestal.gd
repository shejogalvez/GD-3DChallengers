extends Spatial
class_name WeaponPedestal, "res://Assets/Classes/weapon_pedestal_icon.png"

export(PackedScene) var weapon_scene = preload("res://Weapons/Weapon.tscn")

var weapon_instance : Weapon

onready var pedestal_model = $Pedestal/Model
onready var pedestal_collision_shape = $Pedestal/CollisionShape
onready var weapon = $Weapon
onready var weapon_model = $Weapon/Model
onready var weapon_pickup_area = $Weapon/PickupArea
onready var weapon_animation_player= $Weapon/AnimationPlayer
onready var weapon_details_area = $Weapon/DetailsArea
onready var weapon_details = $Weapon/Details
onready var weapon_details_name = $Weapon/Details/Panel/Name
onready var weapon_details_damage = $Weapon/Details/Panel/Damage
onready var weapon_details_shots = $Weapon/Details/Panel/Shots
onready var weapon_details_description= $Weapon/Details/Panel/Description
onready var weapon_pedestal_audio = $WeaponPedestalAudio

# Called when the node enters the scene tree for the first time.
func _ready():
	pedestal_collision_shape.shape = pedestal_model.mesh.create_convex_shape()
	weapon_instance = weapon_scene.instance()
	weapon_model.mesh = weapon_instance.get_node("Model").mesh
	weapon_model.scale = Vector3(1.6, 1.6, 1.6)
	weapon_animation_player.play("rotation")
	weapon_details_name.text = weapon_instance.weapon_name
	weapon_details_damage.text = str(weapon_instance.damage_factor)
	weapon_details_shots.text = str(weapon_instance.projectiles)
	weapon_details_description.text = weapon_instance.weapon_description
	weapon_details.hide()
	weapon_pickup_area.connect("body_entered", self, "give_weapon")
	weapon_details_area.connect("body_entered", self, "show_details")
	weapon_details_area.connect("body_exited", self, "hide_details")
	weapon_pedestal_audio.connect("finished", weapon_pedestal_audio, "queue_free")

# Gives the weapon if area touched by a player.
func give_weapon(body):
	PlayerManager.set_weapon(weapon_instance)
	weapon_pedestal_audio.play()
	weapon.queue_free()

# Shows the weapon details.
func show_details(body):
	weapon_details.show()
	
# Hides the weapon details.
func hide_details(body):
	weapon_details.hide()

extends Spatial
class_name WeaponPedestal, "res://Assets/Classes/pedestal_icon.png"

export(PackedScene) var weapon_scene = preload("res://Weapons/Weapon.tscn")

onready var weapon = $Weapon
onready var weapon_model = $Weapon/Model
onready var weapon_pickup_area = $Weapon/PickupArea
onready var weapon_animation_player= $Weapon/AnimationPlayer
onready var weapon_pedestal_audio = $WeaponPedestalAudio

# Called when the node enters the scene tree for the first time.
func _ready():
	var weapon_instance = weapon_scene.instance()
	weapon_model.mesh = weapon_instance.get_node("Model").mesh
	weapon_model.scale = Vector3(1.6, 1.6, 1.6)
	weapon_animation_player.play("rotation")
	weapon_pickup_area.connect("body_entered", self, "give_weapon")
	weapon_pedestal_audio.connect("finished", weapon_pedestal_audio, "queue_free")
	weapon_instance.queue_free()

# Gives the weapon if area touched by a player.
func give_weapon(body):
	PlayerManager.set_weapon(weapon_scene.instance())
	weapon_pedestal_audio.play()
	weapon.queue_free()

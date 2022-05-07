extends Spatial
class_name WeaponPedestal, "res://Assets/Classes/weapon_pedestal_icon.png"

export(PackedScene) var weapon_scene = preload("res://Weapons/Scenes/Weapon.tscn")
var weapon_instance =  weapon_scene.instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	weapon_instance = weapon_scene.instance()
	$Weapon/Model.mesh = weapon_instance.get_node("Model").mesh
	$Weapon/Model.scale = Vector3(1.6, 1.6, 1.6)
	$Weapon/AnimationPlayer.play("rotation")
	$Weapon/Details/Panel/Name.text = weapon_instance.weapon_name
	$Weapon/Details/Panel/Damage.text = str(weapon_instance.damage_factor)
	$Weapon/Details/Panel/Shots.text = str(weapon_instance.projectiles)
	$Weapon/Details/Panel/Description.text = weapon_instance.weapon_description
	$Weapon/Details.hide()
	$Weapon/PickupArea.connect("body_entered", self, "give_weapon")
	$Weapon/DetailsArea.connect("body_entered", self, "show_details")
	$Weapon/DetailsArea.connect("body_exited", self, "hide_details")
	$WeaponPedestalAudio.connect("finished", self, "remove_audio")

# Gives the weapon if area touched by a player.
func give_weapon(body):
	if body == PlayerManager.get_player():
		PlayerManager.set_weapon(weapon_instance)
		$WeaponPedestalAudio.play()
		$Weapon.queue_free()

# Shows the weapon details.
func show_details(body):
	if body == PlayerManager.get_player():
		$Weapon/Details.show()

# Hides the weapon details.
func hide_details(body):
	if body == PlayerManager.get_player():
		$Weapon/Details.hide()
		
# Removes the audioplayer node.
func remove_audio():
	$WeaponPedestalAudio.queue_free()

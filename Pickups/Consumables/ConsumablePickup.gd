extends Pickup
class_name ConsumablePickup

export(Script) var consumable_class : Script

# Called when the player interacts with the pickup.
func _obtain():
	var consumable : Consumable = consumable_class.new()
	consumable.consumable_icon = interaction.interaction_icon
	consumable.consumable_name = interaction.interaction_message
	var pickup_scene = PackedScene.new()
	pickup_scene.pack(self)
	consumable.pickup_scene = pickup_scene
	PlayerManager.add_consumable(consumable)

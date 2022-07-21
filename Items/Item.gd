extends Node
class_name Item, "res://Assets/Classes/item_icon.png"

# Item image
export(StreamTexture) var item_image
# Item name
export(String) var item_name = "Welcome"
# Item description (lore)
export(String) var item_description = "Controls:           Movement: WASD     Shoot: Left Click          Alt Shoot: Right Click           Sprint: Shift              Jump: Space Bar               Good Luck"

# Item effect (gameplay)
export(String) var item_effect = ""

# Called when the player uses the item.
func use() -> void:
	print("Player used me!")

extends Spatial
class_name Item, "res://Assets/Classes/item_icon.png"

# Item name
export(String) var item_name = "Item"
# Item description (lore)
export(String) var item_description = "This is an standard item intended to be extended."
# Item effect (gameplay)
export(String) var item_effect = "This item does nothing"
# Item image
export(StreamTexture) var item_image

func use():
	print("Player used me!")
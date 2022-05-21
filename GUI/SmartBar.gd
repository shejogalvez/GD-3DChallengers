extends ProgressBar
class_name SmartBar

# Smart bar initial max value
export(int, 1, 99999) var previous_max_value = 1

# Smart value label
onready var smart_value = $SmartValue
	
# Sets the bar value smartly.
func set_smart_value(value : int, max_value : int) -> void:
	self.rect_size *= Vector2(float(max_value) / previous_max_value, 1) 
	self.value = 100 * value / max_value
	smart_value.text = str(value)
	previous_max_value = max_value


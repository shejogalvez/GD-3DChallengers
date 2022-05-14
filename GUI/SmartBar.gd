extends ProgressBar
class_name SmartBar

export(String) var smart_label_text = "Label"

onready var smart_label = $SmartLabel
onready var smart_value = $SmartValue

# Called when the node enters the scene tree for the first time.
func _ready():
	smart_label.text = smart_label_text
	
# Sets the bar value smartly.
func set_smart_value(value, max_value):
	self.value = 100 * value / max_value
	smart_value.text = str(value)


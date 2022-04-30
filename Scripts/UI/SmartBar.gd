extends ProgressBar
class_name SmartBar

export var smart_label : String = "Label"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = smart_label
	
func set_smart_value(value, max_value):
	self.value = 100 * value / max_value
	$Value.text = str(self.value * max_value / 100)


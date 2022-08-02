extends Control

onready var loading_bar := $LoadingBar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Updates the progress.
func update_progress(value : int) -> void:
	loading_bar.value = value

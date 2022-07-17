extends Node

var time = 0
onready var boss = $Boss
onready var grid = $GridMap
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

	
static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func _process(delta):
	time += delta
	
	if Input.is_key_pressed(KEY_R):
		delete_children(self)
		get_tree().reload_current_scene()
		
	if Input.is_key_pressed(KEY_1):
		boss.play("bullet_lotus")
		
	if Input.is_key_pressed(KEY_2):
		boss.play("trail_bullet")
	
	if Input.is_key_pressed(KEY_3):
		boss.play("explosion")
		
	if Input.is_key_pressed(KEY_4):
		boss.play("spawn")
	
	if Input.is_key_pressed(KEY_BACKSLASH):
		boss.play("move")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

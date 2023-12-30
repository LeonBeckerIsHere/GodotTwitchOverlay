extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var window = get_window()
	
	
	await(get_tree().process_frame)

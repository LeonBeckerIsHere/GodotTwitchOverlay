extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var window = get_window()
	#window.mode = Window.MODE_MAXIMIZED
	#window.borderless = !window.borderless
	
	await(get_tree().process_frame)

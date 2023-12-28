extends Control

var following = false
var dragging_start_position = Vector2()

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1:
			following = !following
			dragging_start_position = get_local_mouse_position()

func _process(_delta):
	if following:
		var window_position:Vector2 = get_window().position
		get_window().position = (window_position + get_global_mouse_position() - dragging_start_position)


func _on_CloseButton_pressed():
	get_tree().quit()




	pass # Replace with function body.

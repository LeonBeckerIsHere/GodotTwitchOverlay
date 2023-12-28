extends Button
@export var guppy_scene:PackedScene
@onready var root = get_node("/root/Overlay/Guppies")

func borderless_on_button_up():
	var new_guppy = guppy_scene.instantiate()
	new_guppy.init(Vector2(randi_range(64,1880),980),"a name")
	root.add_child(new_guppy)

func go_window_borderless():
	var window = get_window()
	#var windowId = window.get_window_id()
	#var currentScreenId = DisplayServer.window_get_current_screen(windowId)
	#var viewport = get_viewport()
		#
	#var screenPosition = DisplayServer.screen_get_position(currentScreenId)
	#var screenSize = DisplayServer.screen_get_size(currentScreenId)
#
	#var initialPosition = ProjectSettings.get_setting("display/window/size/initial_position")
	#var viewportWidth = ProjectSettings.get_setting("display/window/size/viewport_width")
	#var viewportHeight = ProjectSettings.get_setting("display/window/size/viewport_height")
	#
	#print(	"\nWindow ID: " + str(windowId) +
			#"\nCurrent Screen ID: " + str(currentScreenId) +
			#"\nWindow Position: " + str(window.position.x) + ", " + str(window.position.y) +
			#"\nScreen Position: " + str(screenPosition.x) + ", " + str(screenPosition.y) +
			#"\nScreen Size: " + str(screenSize.x) + ", " + str(screenSize.y) +
			#"\nInitial Position: " + str(initialPosition.x) + ", " + str(initialPosition.y) + 
			#"\nInitial Viewport Size: " + str(viewportWidth) + ", " + str(viewportHeight) +
			#"\nCurrent Viewport Size: " + str(viewport.size.x) + ", " + str(viewport.size.y))
	
	
	window.borderless = !window.borderless
	
	await(get_tree().process_frame)
	

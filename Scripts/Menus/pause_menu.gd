extends Control

#Pause Menu script only showed when game is paused

#Notification function when we are paused we un/show the Pause Menu
func _notification(what: int) -> void:
	if Global.playerAlive and !Global.finished:
		match what:
			Node.NOTIFICATION_PAUSED: 
				$CanvasLayer.visible = false
				$CanvasLayer/PauseBackgroundColor.visible = false
			Node.NOTIFICATION_UNPAUSED: 
				$CanvasLayer.visible = true
				$CanvasLayer/PauseBackgroundColor.visible = true

#Pressed function we change scene to Main Scene
func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")

#Pressed function we change scene to Controls Scene
func _on_controls_button_pressed() -> void:
	$CanvasLayer/Control.visible = true

#Pressed function we quit from the Controls Scene
func _on_exit_options_texture_button_pressed() -> void:
	$CanvasLayer/Control.visible = false

#Pressed function we quit from the game
func _on_exit_button_pressed() -> void:
	get_tree().quit()

extends Control

#Intro script where we start the animation to end the Game

#We declare onready variables to be ready when we have to start the BackgroundIntro animation
@onready var final_intro: AnimationPlayer = $FinalAnimation

#We declare to only play the BackgroundIntro one time
var playFinalIntro : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#Notification function to play the animation because the rest of the nodes are only showed when is paused
func _notification(_what: int) -> void:
	if Node.NOTIFICATION_PAUSED and Global.finished: play_animation()

#Function to play the animation only on time
func play_animation():
	if !playFinalIntro:
		playFinalIntro = true
		$FinalAnimation.play("finish")

#Pressed function we change scene to Main Scene and we Unpause the game
func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")

#Pressed function we quit from the game
func _on_exit_button_pressed() -> void:
	get_tree().quit()

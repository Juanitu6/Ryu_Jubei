extends Control

#Intro script where we start the animation

#We declare onready variables to be ready when we have to start the Intro animation
@onready var startAnimation : AnimationPlayer = $StartAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	startAnimation.play("FadeIn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#AnimationFinished function starts the Main menu scene
func _on_start_animation_animation_finished(_anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")

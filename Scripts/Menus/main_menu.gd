extends Control

#Main Menu script where we can choose the diferent options

#We declare some onready variables to be ready when we have to start using them

#AnimationIntro
@onready var animation : AnimationPlayer = $AnimationIntro

#BackGroundMainMenu
@onready var backGroundColor : ColorRect = $ControlMainMenuColor/backGroundColor
@onready var frontGroundColor : ColorRect = $ControlMainMenuColor/frontGroundColor

#TextureRectMenuTitle
@onready var menuTitle : TextureRect = $PlayMenu/menuTitle

#VBoxContainerMenus
@onready var menuVBox : VBoxContainer = $PlayMenu/MenuVBox
@onready var optionMenuVBox : VBoxContainer = $PlayMenu/OptionsMenuVBox
@onready var creditsMenuVBox : VBoxContainer = $PlayMenu/CreditsMenuVBox

#Sprite2D Controls
@onready var controls : Sprite2D = $PlayMenu/OptionsMenuVBox/Controls

#Sprite2D Credits
@onready var godot : Sprite2D = $PlayMenu/CreditsMenuVBox/GodotImage
@onready var register : Sprite2D = $PlayMenu/CreditsMenuVBox/RegisterImage

#TextureButtonsOptions
@onready var controlButton : TextureButton = $PlayMenu/MenuVBox/ControlsTextureButton
@onready var creditsButton : TextureButton = $PlayMenu/MenuVBox/CreditsTextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.playerAlive = true
	Global.finished = false
	animation.play("FadeOut")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#Scene Manager function
func make_menu_visible(option):
	match option:
		controlButton:
			menuVBox.visible = false
			optionMenuVBox.visible = true
			menuTitle.texture = load("res://Aseprite/Menus/MainMenu/ControlsTitle.png")
			controls.visible = true
		creditsButton:
			menuVBox.visible = false
			creditsMenuVBox.visible = true
			godot.visible = true
			register.visible = true
			menuTitle.texture = load("res://Aseprite/Menus/MainMenu/CreditsTitle.png")

#Pressed function we change scene to Main Scene
func _on_play_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

#Pressed function we change scene to Controls Scene
func _on_options_texture_button_pressed() -> void:
	make_menu_visible(controlButton)

#Pressed function we change scene to Credits Scene
func _on_credits_texture_button_pressed() -> void:
	make_menu_visible(creditsButton)

#Pressed function we quit from the game
func _on_exit_texture_button_pressed() -> void:
	get_tree().quit()

#Pressed function we change back to Main Menu Scene
func _on_exit_options_texture_button_pressed() -> void:
	optionMenuVBox.visible = false
	controls.visible = false
	menuTitle.texture = load("res://Aseprite/Menus/MainMenu/MainMenuTitle.png")
	menuVBox.visible = true

#Pressed function we change back to Main Menu Scene
func _on_exit_credits_texture_button_pressed() -> void:
	creditsMenuVBox.visible = false
	godot.visible = false
	register.visible = false
	menuTitle.texture = load("res://Aseprite/Menus/MainMenu/MainMenuTitle.png")
	menuVBox.visible = true

#We set a variable to not visible when an animation finishes
func _on_animation_intro_animation_finished(_anim_name: StringName) -> void:
	$ControlIntro.visible = false

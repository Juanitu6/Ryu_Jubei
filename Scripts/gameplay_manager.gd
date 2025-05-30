extends Node

#GamePlayManager script

#We declare a variable boolean to not play the DeadMenu loop times
var playerDeadMenu : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerDeadMenu = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !Global.playerAlive: pauseDead()
	elif Input.is_action_just_pressed("pause"): toggle_pause()

# Function to toggle the pause
func toggle_pause():
	get_tree().paused = !get_tree().paused

# Function to pauseDead
func pauseDead():
	if !playerDeadMenu:
		playerDeadMenu = true
		await get_tree().create_timer(3.5).timeout
		toggle_pause()

# Function to initialize the spawn of potions
func pauseFinish():
	if !Global.finished:
		Global.finished = true
		toggle_pause()

# Function restart the pause
func _on_resume_button_pressed() -> void:
	toggle_pause()

#Function on area entered to start finish Animation
func area_finish(area: Area2D) -> void:
	if Global.playerAlive and area.get_parent() == Global.playerBody and area.name == "PlayerHitbox": 
		pauseFinish()

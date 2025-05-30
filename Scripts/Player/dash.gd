extends Node

#Dash script

#We declare some onready variables to be ready when we have to start using them

#Player
@onready var player: Player = $"../.."

#DashTimer
@onready var dash_timer: Timer = $DashTimer

#Constant Player components
const dash_speed: int = 350
const normal_speed: int = 35

#Boolean Player components
var _can_dash: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	player.velocity.x = dash_speed * player._direction if is_dashing() else normal_speed * player._direction

#Function to start Dash
func start_dash():
	dash_timer.start()
	_can_dash = false

#Function to return if Player is dashing
func is_dashing():
	return !dash_timer.is_stopped()

#Function to return if the Player can dash
func can_dash():
	return _can_dash

#Timeout function that triggers when the cooldown from the dash is finished
func _on_dash_timer_timeout() -> void:
	await get_tree().create_timer(5).timeout
	_can_dash = true

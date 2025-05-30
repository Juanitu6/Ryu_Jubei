extends Node

#Jump&Wall script

#We declare some onready variables to be ready when we have to start using them

#Player
@onready var player: Player = $"../.."

#Constant Player components
const wall_jump_pushback = 150
const wall_slide_gravity = 100
const jump_power = -400
const max_jump = 2

#Boolean Player components
var is_jumping: bool = false

#Int Player components
var numberJumps: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#Funtion to let the Player jump
func jump():
	player.velocity.y = jump_power
	numberJumps += 1

#Funtion return if Player can jump
func can_jump():
	return numberJumps < max_jump

#Funtion to reset Player number of jumps
func reset_jumps():
	numberJumps = 0

#Funtion to let the Player WallJump
func wall_jump(_delta, direction):
	if direction > 0: player.velocity.x = -wall_jump_pushback
	elif direction < 0: player.velocity.x = wall_jump_pushback

#Funtion to set variables when Player is WallSliding
func wall_slide(delta):
	player.velocity.y = player.velocity.y + (wall_slide_gravity * delta)
	player.velocity.y = min(player.velocity.y, wall_slide_gravity)

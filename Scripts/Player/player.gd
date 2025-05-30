extends CharacterBody2D

class_name Player

#Player script

#We declare some onready variables to be ready when we have to start using them

#Player functions
@onready var playerDash: Node = $"Functions/Dash"
@onready var playerJump: Node = $"Functions/Jump&WallJump"
@onready var playerDamage: Node = $"Functions/Damage"

#Player Health
@onready var playerHealth : Node = $"Health"

#Player Animations
@onready var playerAnimation: AnimationPlayer = $AnimationPlayer
@onready var playerSprite : Sprite2D = $PlayerSprite

#Constant Player components
const _gravity = 20
const _normal_speed = 35
const _run_speed = 80

#Boolean Player components
var _current_attack: bool = false
var _is_dead: bool = false

#Int Player components
var _actual_speed: int
var _direction: float = 1

#String Player components
var _attack_type: String

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.playerBody = self
	Global.playerAlive = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_animations()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	Global.playerHitbox = $PlayerHitbox

	velocity.y += _gravity

	if !playerHealth.is_dead():
		
		_direction = Input.get_axis("left","right")

		if is_on_floor(): playerJump.reset_jumps()

		if Input.is_action_just_pressed("jump") and playerJump.can_jump(): playerJump.jump()

		if is_on_wall() and !is_on_floor():
			if Input.is_action_pressed("left") or Input.is_action_pressed("right"): playerJump.wall_slide(delta)
			if Input.is_action_just_pressed("jump") and (Input.is_action_pressed("left") or Input.is_action_pressed("right")): playerJump.wall_jump(delta, _direction)

		if Input.is_action_just_pressed("dash") && playerDash.can_dash(): playerDash.start_dash()

		if Input.is_action_pressed("run"): _actual_speed = _run_speed
		else: _actual_speed = _normal_speed

		if !playerDash.is_dashing(): velocity.x = _actual_speed * _direction

		if !_current_attack and is_on_floor():
			if Input.is_action_just_pressed("left_mouse") or Input.is_action_just_pressed("right_mouse"):
				_current_attack = true
				if Input.is_action_just_pressed("left_mouse") and is_on_floor(): _attack_type = "1"
				elif Input.is_action_just_pressed("right_mouse") and is_on_floor(): _attack_type = "2"
				playerDamage.set_damage(_attack_type)
				handle_attack_animation(_attack_type)

		if _direction != 0:
			if playerDamage.punch1_disabled() and playerDamage.punch2_disabled():
				switch_direction(_direction)
	else: velocity.x = 0

	if playerHealth.player_can_move():
		if playerDamage.punch1_disabled() and playerDamage.punch2_disabled(): move_and_slide()

#Function to switch player direction & colisions
func switch_direction(horizontal_direction):
	playerSprite.flip_h = (horizontal_direction == -1)
	playerDamage.switch_direction_colisions(horizontal_direction)

#Function to handle the attack type animations
func handle_attack_animation(attack_animation):
	if _current_attack:
		var animation = str("player_punch", attack_animation)
		playerAnimation.play(animation)
		playerDamage.toggle_damage_collisions(animation)

#Function to play death animation when the Player dies
func final_animation():
	$PlayerColision.position.y = 5
	playerAnimation.play("player_death")
	await get_tree().create_timer(3.5).timeout

#Function to handle the animations of the Player
func update_animations():
	if playerHealth.is_dead() and !_is_dead:
		_is_dead = true
		final_animation()
	elif !_is_dead:
		if playerDash.is_dashing(): 
			playerAnimation.play("player_dash")
		elif is_on_floor() and !is_on_wall():
			if !_current_attack and playerHealth.is_getting_healed(): playerAnimation.play("player_heal")
			elif !_current_attack and !playerHealth.getting_damaged():
				if velocity.x == 0: playerAnimation.play("player_idle")
				elif _actual_speed == abs(_normal_speed): playerAnimation.play("player_walk")
				elif _actual_speed == abs(_run_speed): playerAnimation.play("player_run")
			elif !_current_attack and playerHealth.getting_damaged(): playerAnimation.play("player_hurt")
		elif !is_on_floor() and !is_on_wall() and !_current_attack:
			if velocity.y > 0: playerAnimation.play("player_fall")
			elif velocity.y <= 0: playerAnimation.play("player_jump")
		elif is_on_wall() and !is_on_floor() and velocity.y > 0: playerAnimation.play("player_wall_slide")

#Timeout Function triggered when the attack animation has finished 
func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	_current_attack = false

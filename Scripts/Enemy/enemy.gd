extends CharacterBody2D

class_name enemy

#Enemy script

#We declare some onready variables to be ready when we have to start using them

#EnemySprites
@onready var enemySprite: Sprite2D = $EnemySprite
@onready var background: Sprite2D = $Background
@onready var health_bar: Sprite2D = $HealthBar

#AnimationPlayer & CollisionShape
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $EnemyWeapon/CollisionShape2D

#Constant Enemy components
const gravity: int = 20
const max_health: int = 4
const min_health: int = 0

#Boolean Enemy components
var dead: bool = false
var taking_damage: bool = false
var is_dealing_damage: bool = false
var is_enemy_chase: bool = false
var is_already_dead: bool = false
var is_moving: bool = true
var is_on_border: bool = false

#Int Enemy components
var health: int = 4
var damage_to_deal: int = 1
var knockback_force: int = -30
var speed: float = 25

#Vector2 Enemy direction compoments
var dir: Vector2

#CharacterBody2D Enemy
var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$EnemyChase/CollisionShape2D2.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player = Global.playerBody

	handle_enemy_health(delta)
	
	if $EnemyChase/CollisionShape2D2.disabled:
		await get_tree().create_timer(1).timeout
		$EnemyChase/CollisionShape2D2.disabled = false

	if !Global.playerAlive: is_enemy_chase = false

	#if !is_on_floor():
		#if !dead:
			#velocity.y += gravity * delta
			#velocity.x = 0

	if (!$RayCastR.is_colliding() and dir.x == 1 or !$RayCastL.is_colliding() and dir.x == -1) and is_on_floor(): switch_direction_on_border(dir)
	else: is_on_border = false

	_switch_direction(dir.x)

	if is_moving and !is_dealing_damage:
		move(delta)
		move_and_slide()
	handle_animation()

#Function to switch the enemy direction
func _switch_direction(horizontal_direction):
	enemySprite.flip_h = (horizontal_direction == -1)
	if horizontal_direction == -1: $EnemyWeapon.scale.x = -1
	elif horizontal_direction == 1: $EnemyWeapon.scale.x = 1

func switch_direction_on_border(horizontal_direction):
	is_on_border = true
	velocity.x = 0
	if !is_enemy_chase:
		if horizontal_direction == Vector2.RIGHT: dir = Vector2.LEFT
		elif horizontal_direction == Vector2.LEFT: dir = Vector2.RIGHT

#Function to handle the health bar texture
func handle_enemy_health(_delta):
	if health == 4: health_bar.texture = load("res://Aseprite/GUI/HealthBar/HealthBar1.png")
	elif health == 3: health_bar.texture = load("res://Aseprite/GUI/HealthBar/HealthBar2.png")
	elif health == 2: health_bar.texture = load("res://Aseprite/GUI/HealthBar/HealthBar3.png")
	elif health == 1: health_bar.texture = load("res://Aseprite/GUI/HealthBar/HealthBar4.png")
	else: health_bar.texture = load("res://Aseprite/GUI/HealthBar/BackgroundVidaBuit.png")

#Function to manage the moving options of the Enemy
func move(delta):
	if !dead:
		if !is_enemy_chase and !is_dealing_damage: velocity += dir * speed * delta
		elif is_enemy_chase and !taking_damage and Global.playerAlive:
			var dir_to_player = global_position.direction_to(player.global_position) * speed
			if !is_on_border or (is_on_border and (dir_to_player.x > 0 and dir.x < 0 or dir_to_player.x < 0 and dir.x > 0)): 
				velocity.x = dir_to_player.x
				dir.x = abs(velocity.x) / velocity.x
		elif taking_damage:
			var knockback_dir = global_position.direction_to(player.global_position) * knockback_force
			velocity.x = knockback_dir.x
	elif dead:
		velocity.x = 0

#Function to handle the animations of the Enemy
func handle_animation():
	if !dead and !taking_damage and !is_dealing_damage and !is_moving:
		animation_player.play("enemy_idle")
	elif !dead and !taking_damage and !is_dealing_damage and is_moving:
		animation_player.play("enemy_walk")
	elif !dead and taking_damage and !is_dealing_damage:
		animation_player.play("enemy_hurt")
		await get_tree().create_timer(0.5).timeout
		taking_damage = false
	elif dead and !is_already_dead:
		is_already_dead = true
		animation_player.play("enemy_death")
		await get_tree().create_timer(1.0).timeout
		handle_death()
	elif !dead and is_dealing_damage:
		animation_player.play("enemy_basic1")

#Function to handle the Enemy death
func handle_death():
	await get_tree().create_timer(1).timeout
	self.queue_free()

#Function return state of Enemy
func isDead():
	return dead

#Function that changes the direction every X seconds
func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = choose([1.5,2.0,2.5])
	if !is_enemy_chase:
		dir = choose([Vector2.RIGHT,Vector2.LEFT])
		velocity.x = 0

#Function to select the random time that will be used on the direction function
func choose(array):
	array.shuffle()
	return array.front()

#Area entered function to know if the area is from the Player Damage Zone
func _on_enemy_hit_box_area_entered(area: Area2D) -> void:
	if area == Global.playerDamageZone1: take_damage(Global.playerDamageAmount)

#Function to apply damage to the Enemy
func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= min_health:
		health = min_health
		dead = true
		final_function()
	print(str(self), " current health is ", health)

#Function to make disable the collisions when the Enemy dies
func final_function():
	$EnemyDealDamageArea/CollisionShape2D.set_deferred("disabled", true)
	$EnemyHitBox/CollisionShape2D.set_deferred("disabled", true)
	$EnemyWeapon/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)

#OnAreaEntered Function to know if the Enemy has to look at the player or not
func _on_enemy_deal_damage_area_area_entered(area: Area2D) -> void:
	if area == Global.playerHitbox: is_dealing_damage = true

#OnAreaEntered Function to know if the Enemy has to look at the player or not
func _on_enemy_deal_damage_area_area_exited(area: Area2D) -> void:
	if area == Global.playerHitbox:
		await get_tree().create_timer(0.2).timeout
		is_dealing_damage = false

#OnAreaEntered Function to know if the Player entered in the zone
func _on_enemy_chase_area_entered(area: Area2D) -> void:
	if  Global.playerAlive and area.get_parent() == Global.playerBody and area.name == "PlayerHitbox":
		is_moving = true
		is_enemy_chase = true
		speed *= 1.5

#OnAreaEntered Function to know if the Player exited in the zone
func _on_enemy_chase_area_exited(area: Area2D) -> void:
	if Global.playerAlive and area.get_parent() == Global.playerBody and area.name == "PlayerHitbox":
		is_enemy_chase = false
		speed = 25

#Timeout Function to let the Enemy move with liberty or stay on position, changes every X time
func _on_moving_timer_timeout() -> void:
	if is_moving and !is_enemy_chase: is_moving = false
	elif !is_moving: is_moving = true
	$MovingTimer.start()

extends CharacterBody2D

class_name enemy_practice

#EnemyPractice script

#We declare some onready variables to be ready when we have to start using them

#EnemySprites
@onready var enemySprite: Sprite2D = $EnemySprite
@onready var background: Sprite2D = $Background
@onready var health_bar: Sprite2D = $HealthBar

#AnimationPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#Constant Enemy components
const gravity = 20
const max_health: int = 1
const min_health: int = 0

#Boolean Enemy components
var dead: bool = false
var is_dead: bool = false
var taking_damage: bool = false
var is_enemy_chase: bool

#Int Enemy components
var health: int = 1

#Vector2 Enemy direction
var dir: Vector2

#Player component to assign as Global CharacterBody2D
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
	
	_switch_direction()
	handle_animation()

#Function to switch the EnemyTest direction
func _switch_direction():
	if !dead and is_enemy_chase and !taking_damage and Global.playerAlive:
		var dir_to_player = global_position.direction_to(player.global_position)
		dir.x = abs(dir_to_player.x) / dir_to_player.x
		enemySprite.flip_h = (dir.x == -1)

#Function to handle the health bar texture
func handle_enemy_health(_delta):
	if health == 1: health_bar.texture = load("res://Aseprite/GUI/HealthBar/HealthBarFull.png")
	else: health_bar.texture = load("res://Aseprite/GUI/HealthBar/BackgroundVidaBuit.png")

#Function to handle the animations of the EnemyTest
func handle_animation():
	if !dead and !taking_damage:
		animation_player.play("enemy_idle")
	elif !dead and taking_damage:
		animation_player.play("enemy_hurt")
		await get_tree().create_timer(0.5).timeout
		taking_damage = false
	elif dead and !is_dead:
		is_dead = true
		animation_player.play("enemy_death")
		await get_tree().create_timer(1.0).timeout
		handle_death()

#Function to handle the EnemyTest death
func handle_death():
	await get_tree().create_timer(1).timeout
	self.queue_free()

#Function return state of EnemyTest
func isDead():
	return is_dead

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

#Function to apply damage to the EnemyTest
func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= min_health:
		health = min_health
		dead = true
		final_animation()
	print(str(self), " current health is ", health)

#Function to make disable the collisions when the EnemyTest dies
func final_animation():
	$EnemyHitBox/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)

#OnAreaEntered Function to know if the EnemyTest has to look at the player or not
func _on_enemy_chase_area_entered(area: Area2D) -> void:
	if Global.playerAlive and area.get_parent() == Global.playerBody: is_enemy_chase = true

#OnAreaEntered Function to know if the EnemyTest has to look at the player or not
func _on_enemy_chase_area_exited(area: Area2D) -> void:
	if Global.playerAlive and area.get_parent() == Global.playerBody: is_enemy_chase = false

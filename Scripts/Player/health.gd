extends Node

#Health script

#We declare some onready variables to be ready when we have to start using them

#Player
@onready var player: Player = $".."

#Heal Timers
@onready var heal_timer: Timer = $Heal/HealCooldown
#CurrentHealth
@export var _currentHealth : int = 4

#Constant Player components
const _maxHealth: int = 4

#Boolean Player components
var _heal_cooldown: bool = false
var _enemy_attack: bool = false
var _damage_zone: bool = false
var _is_getting_healed: bool = false
var _is_getting_damaged: bool = false
var _hit_cooldown: bool = false
var _dead: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_pass : float) -> void:
	can_get_heal()
	can_get_damage()

#Function to return if Player can move
func player_can_move():
	return !_is_getting_healed and !_is_getting_damaged

#Function to know if Player can get a heal
func can_get_heal():
	if player.is_on_floor() and Global.healZone and !_heal_cooldown:
		if _currentHealth > 0 and _currentHealth <= 3:
			if !_is_getting_healed:
				_is_getting_healed = true
				play_timer_heal()
				heal()

#Function to start the cooldown heal timer
func play_timer_heal():
	heal_timer.start()

#Function to heal the Player
func heal():
	_currentHealth += 1

#Function to return the current health from the Player
func currentHealth():
	return _currentHealth

#Function to know if Player is getting healed
func is_getting_healed():
	return _is_getting_healed

#Timeout function triggered when cooldown from healing is finished
func _on_heal_timer_timeout() -> void:
	_is_getting_healed = false
	_heal_cooldown = true
	await get_tree().create_timer(5).timeout
	_heal_cooldown = false

#Function if the Player can get damage
func can_get_damage():
	if (player.is_on_floor() or player.is_on_wall()) and !_is_getting_damaged:
		if _enemy_attack: take_damage(1)
		elif _damage_zone and !_hit_cooldown: take_damage(1)

#Area entered function where we handle the diferent actions on the Player
func _on_player_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent().name.begins_with("Enemy") and area.name.begins_with("EnemyWeapon"): _enemy_attack = true
	elif area == Global.fallZone: fall_damage()
	elif area.get_parent().name.begins_with("HealPotion") and _currentHealth != 4: Global.healZone = true
	elif area.get_parent().name.begins_with("HitZone"): _damage_zone = true

#Area exited function where we handle the diferent actions on the Player
func _on_player_hitbox_area_exited(area: Area2D) -> void:
	if area.get_parent().name.begins_with("Enemy") and area.name.begins_with("EnemyWeapon"): _enemy_attack = false
	elif area.get_parent().name.begins_with("HitZone"): _damage_zone = false

#Function when Player enter on this area instantly dies
func fall_damage():
	_currentHealth = 0
	_dead = true
	Global.playerAlive = false

#Function to return if Player is getting damaged
func getting_damaged():
	return _is_getting_damaged

#Function makes the Player take damage
func take_damage(damage):
	if damage != 0:
		if _currentHealth > 0:
			_currentHealth -= damage
			print("Player health: ", _currentHealth)
			if _currentHealth <= 0: final_animation()
			taking_damage(1)

#Function to make disable the collisions when the Player dies
func final_animation():
	_currentHealth = 0
	_dead = true
	$"../PlayerHitbox/CollisionShape2D".set_deferred("disabled", true)
	$"../PunchArea2D/CSPunch1".set_deferred("disabled", true)
	$"../PunchArea2D/CSPunch2".set_deferred("disabled", true)
	Global.playerAlive = false

#Function to start the cooldown from the Player to get damaged
func taking_damage(wait_time):
	_is_getting_damaged = true
	await get_tree().create_timer(wait_time).timeout
	if _damage_zone:
		_hit_cooldown = true
		$Hit/HitCooldown.start()
	_is_getting_damaged = false

#Timeout function to finish the hit cooldown
func _on_hit_cooldown_timeout() -> void:
	_hit_cooldown = false

#Function to return state of Player
func is_dead():
	return _dead

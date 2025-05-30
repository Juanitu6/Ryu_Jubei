extends Node

#Damaged script

#We declare some onready variables to be ready when we have to start using them

#Punches
@onready var punch_1_area_2d: Area2D = $"../../PunchArea2D"
@onready var punch_1: CollisionShape2D = $"../../PunchArea2D/CSPunch1"
@onready var punch_2: CollisionShape2D = $"../../PunchArea2D/CSPunch2"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	punch_1.disabled = true
	punch_2.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	Global.playerDamageZone1 = punch_1_area_2d

#Function return if punch1 is disabled
func punch1_disabled():
	return punch_1.disabled

#Function return if punch2 is disabled
func punch2_disabled():
	return punch_2.disabled

#Function to switch the collision direction
func switch_direction_colisions(horizontal_direction):
	if horizontal_direction == 1: punch_1_area_2d.scale.x = 1
	if horizontal_direction == -1: punch_1_area_2d.scale.x = -1

#Function that toggles the collision of the type of attack
func toggle_damage_collisions(current_attack):
	var wait_time: float
	if current_attack == "player_punch1":
		wait_time = 0.7 #Time to get the animation on point
		punch_1.disabled = false
	if current_attack == "player_punch2":
		wait_time = 0.4
		punch_2.disabled = false
	await get_tree().create_timer(wait_time).timeout
	punch_1.disabled = true
	punch_2.disabled = true

#Function to set the damage for every type of attack
func set_damage(attack_type):
	var current_damage_to_deal: int
	if attack_type == "1": current_damage_to_deal = 2
	if  attack_type == "2": current_damage_to_deal = 1
	Global.playerDamageAmount = current_damage_to_deal

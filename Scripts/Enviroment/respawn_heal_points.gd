extends Node2D

#Spawn Heal Points script

#We declare some onready variables to be ready when we have to start using them

#Enemys PackedScenes
@export var heal_potion: PackedScene

#Boolean if can spawn a new potion
var can_spawn: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if self.get_child_count() == 0 and can_spawn: spawn()

#Function to initialize the spawn of potions
func spawn():
	can_spawn = false
	var heal_point
	heal_point = heal_potion.instantiate()
	heal_point.position = Vector2(0,0)
	self.add_child(heal_point)

#Function to start the timer
func start_timer():
	await get_tree().create_timer(10).timeout
	can_spawn = true

#Function to detect if a node is exiting
func heal_point_exit(node: Node) -> void:
	if node.is_in_group("Heal"): start_timer()

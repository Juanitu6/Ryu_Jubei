extends Marker2D

#EnemyPracticeSpawnPoint script

#We export the enemy practice as a packed scene to instanstiate it
@export var enemy_practice_packed_scene: PackedScene

#We declare a variable boolean to let spawn an enemy or not after the cooldown
var can_spawn: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	can_spawn = false
	make_spawn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if get_child_count() == 0 and can_spawn: make_spawn()

#Function to instantiate the enemy practice
func make_spawn():
	can_spawn = false
	var enemy_scene = enemy_practice_packed_scene.instantiate()
	enemy_scene.position = Vector2(0,0)
	self.add_child(enemy_scene)

#Function to start the timer
func start_timer():
	await get_tree().create_timer(10).timeout
	can_spawn = true

#OnChildExiting function that starts timer when child node exited
func enemy_spawn_point(node: Node) -> void:
	if node.is_in_group("EnemyPractice"): start_timer()

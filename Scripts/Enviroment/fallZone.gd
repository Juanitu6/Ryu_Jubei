extends Area2D

#Fall script

#Export the packedscene from the lava to instantiate many particles scenes
@export var lavaP: PackedScene

#Variable bool to not condition the show of particles
var player_is_in: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.fallZone = self
	player_is_in = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player_is_in: createP(Global.playerBody.global_position)

#Func where we instantiate the particles in the position of the player
func createP(pos):
	var value = randi_range(-10, 10)
	var newP = lavaP.instantiate()
	newP.global_position = Vector2(pos.x + value, pos.y)
	$Particles.add_child(newP)

#OnAreaEntered we set to true the boolean value to show on the particles
func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() == Global.playerBody and area.name == "PlayerHitbox":
		player_is_in = true

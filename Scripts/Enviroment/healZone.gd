extends Node2D

#HealZone script

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPotion.play("idle_potion")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#Function on entered when player enters queue.free
func _on_area_potion_area_entered(area: Area2D) -> void:
	if area == Global.playerHitbox:
		await get_tree().create_timer(0.8).timeout
		Global.healZone = false
		self.queue_free()

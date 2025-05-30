extends GPUParticles2D

#Script to emmit particles

#Func where we set to emmit particles
func _ready() -> void:
	emitting = true

#Func to clear the particles to no generate lag
func _process(_delta: float) -> void:
	if not emitting:
		queue_free()

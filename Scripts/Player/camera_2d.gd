extends Camera2D

var fixed_y_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fixed_y_position = -50

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position.y = fixed_y_position
	print($Player/Camera2D.y)

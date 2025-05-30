extends CanvasLayer

#CanvasHealth script

#We declare some onready variables to be ready when we have to start using them

#Dash
@onready var player_dash: Node = $"../../Functions/Dash"
@onready var dash_key: Sprite2D = $DashKey

#Health
@onready var health: Node = $"../../Health"
@onready var background: Sprite2D = $Background
@onready var health_bar: Sprite2D = $HealthBar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if health.currentHealth() == 4: health_bar.texture = load("res://Aseprite/GUI/HealthBar/HealthBar1.png")
	elif health.currentHealth() == 3: health_bar.texture = load("res://Aseprite/GUI/HealthBar/HealthBar2.png")
	elif health.currentHealth() == 2: health_bar.texture = load("res://Aseprite/GUI/HealthBar/HealthBar3.png")
	elif health.currentHealth() == 1: health_bar.texture = load("res://Aseprite/GUI/HealthBar/HealthBar4.png")
	else: health_bar.texture = load("res://Aseprite/GUI/HealthBar/BackgroundVidaBuit.png")

	if player_dash.can_dash(): dash_key.texture = load("res://Aseprite/GUI/TeclaDash.png")
	elif !player_dash.can_dash(): dash_key.texture = load("res://Aseprite/GUI/TeclaDashCooldown.png")

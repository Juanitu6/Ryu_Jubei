extends Node2D

#Global Script where we declare global atributes

#PlayerBody
var playerBody: CharacterBody2D

#Player components
var playerAlive: bool = true
var playerDamageAmount: int
var playerDamageZone1: Area2D
var playerHitbox: Area2D

#Map components
var fallZone: Area2D
var healZone: bool = false
var finished: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

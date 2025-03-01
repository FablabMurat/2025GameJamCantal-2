class_name CharacterStats
extends Resource

signal health_change

@export var health: int:
	set(value):
		health = value
		health_change.emit()

@export var speed: int
@export var jump_strength: int
@export var gravity: int

func _init(base_health: int = 100, base_speed: int = 300, base_jump_strength: int = 400, base_gravity: int = 900) -> void:
	health = base_health
	speed = base_speed
	jump_strength = base_jump_strength
	gravity = base_gravity

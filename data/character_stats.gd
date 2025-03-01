class_name CharacterStats
extends Resource

signal health_change

@export var health: int:
	set(value):
		health = value
		health_change.emit()

@export var speed: int

func _init(base_health: int = 100, base_speed: int = 200) -> void:
	health = base_health
	speed = base_speed

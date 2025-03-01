class_name CharacterData
extends Resource

@export var display_name: String
@export var sprite_frames: SpriteFrames
# INPUT: String
@export var attacks: Dictionary
@export var stats: CharacterStats
@export var collision_shape: Shape2D
@export var sprite_offset: Vector2

func _init(name: String = "Placeholder", sprite: SpriteFrames = null, collisions: Shape2D = null, base_stats: CharacterStats = null, animated_sprite_offset: Vector2 = Vector2.ZERO) -> void:
	display_name = name
	sprite_frames = sprite
	stats = base_stats
	collision_shape = collisions
	sprite_offset = animated_sprite_offset

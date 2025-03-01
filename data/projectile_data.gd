class_name ProjectileData
extends Object

var sprite_frames: SpriteFrames
var collision_shape: Shape2D
var speed: int

func _init(sprite: SpriteFrames, collisions: Shape2D, move_speed: int) -> void:
	sprite_frames = sprite;
	collision_shape = collisions;
	speed = move_speed;

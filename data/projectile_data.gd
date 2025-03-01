class_name ProjectileData
extends Object

var sprite_frames: SpriteFrames
var collision_shape: Shape2D
var speed: int
# func(projectile: Projectile, body: Node2D)
var collision_handler: Callable
var lifetime: int

func _init(sprite: SpriteFrames, collisions: Shape2D, move_speed: int, on_collision: Callable, life_time: int = -1) -> void:
	sprite_frames = sprite;
	collision_shape = collisions;
	speed = move_speed;
	collision_handler = on_collision;
	lifetime = life_time

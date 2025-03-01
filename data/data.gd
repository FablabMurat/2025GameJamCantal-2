extends Node

enum DeathReason { VOID, NO_HEALTH };

const PROJECTILE_SPEED_FAST: int = 500

var EXPLODE_ON_COLLIDE = func(projectile: Projectile, body: Node2D) -> void:
	if body is Player:
		(body as Player).stats.health -= 10;
	projectile.queue_free()

var PROJECTILES_DATA: Dictionary = {
	"camelia_missile": ProjectileData.new(
		preload("res://resources/projectiles/camelia_missile_sprite_frames.tres"),
		preload("res://resources/projectiles/camelia_missile_shape.tres"),
		PROJECTILE_SPEED_FAST,
		EXPLODE_ON_COLLIDE
	),
}

var CHARACTERS_DATA: Dictionary = {
	"cyclamen": CharacterData.new(
		"Cyclamen",
		preload("res://resources/characters/cyclamen_sprite_frames.tres"),
		null,
		CharacterStats.new(100, 400)
	),
	"camelia": CharacterData.new(
		"Camelia",
		preload("res://resources/characters/camelia_sprite_frames.tres"),
		null,
		CharacterStats.new(100, 200)
	),
	"sauge": CharacterData.new(
		"Sauge",
		preload("res://resources/characters/sauge_sprite_frames.tres"),
		preload("res://resources/characters/sauge_collision_shape.tres"),
		CharacterStats.new(100, 200)
	),
}

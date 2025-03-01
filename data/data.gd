extends Node

enum DeathReason { VOID, NO_HEALTH };

enum ProjectileSpeed {PROJECTILE_SPEED_FAST = 500}

enum CharacterSpeed {
	CHARACTER_SPEED_FAST = 500,
	CHARACTER_SPEED_MEDIUM = 300
};

enum JumpStrength {
	JUMP_STRENGTH_HIGH = 600,
	JUMP_STRENGTH_MEDIUM = 400
};

enum Gravity {
	GRAVITY_LOW = 600,
	GRAVITY_MEDIUM = 800,
	GRAVITY_HIGH = 1000
}


var DAMAGE_ON_COLLIDE = func(projectile: Projectile, body: Node2D) -> void:
	if body is Player:
		(body as Player).stats.health -= 10;
	projectile.queue_free()

var EXPLODE_ON_COLLIDE = func(projectile: Projectile, body: Node2D) -> void:
	DAMAGE_ON_COLLIDE.call(projectile, body);


var PROJECTILES_DATA: Dictionary = {
	"camelia_missile": ProjectileData.new(
		preload("res://resources/projectiles/camelia_missile_sprite_frames.tres"),
		preload("res://resources/projectiles/camelia_missile_shape.tres"),
		ProjectileSpeed.PROJECTILE_SPEED_FAST,
		EXPLODE_ON_COLLIDE
	),
	"sauge_leaf": ProjectileData.new(
		preload("res://resources/projectiles/sauge_leaf_sprite_frames.tres"),
		preload("res://resources/projectiles/sauge_leaf_shape.tres"),
		ProjectileSpeed.PROJECTILE_SPEED_FAST,
		DAMAGE_ON_COLLIDE
	),
}

var CHARACTERS_DATA: Dictionary = {
	"sauge": CharacterData.new(
		"Sauge",
		"sauge_leaf",
		preload("res://resources/characters/sauge_sprite_frames.tres"),
		preload("res://resources/characters/sauge_collision_shape.tres"),
		CharacterStats.new(120, CharacterSpeed.CHARACTER_SPEED_MEDIUM, JumpStrength.JUMP_STRENGTH_MEDIUM, Gravity.GRAVITY_HIGH)
	),
	"muguet": CharacterData.new(
		"Muguet",
		"camelia_missile",
		preload("res://resources/characters/muguet_sprite_frames.tres"),
		preload("res://resources/characters/muguet_collision_shape.tres"),
		CharacterStats.new(80, CharacterSpeed.CHARACTER_SPEED_FAST, JumpStrength.JUMP_STRENGTH_HIGH, Gravity.GRAVITY_MEDIUM),
		Vector2(0, -70)
	),
}

extends Node

enum Season{SUMMER, AUTUMN, WINTER, SPRING}
var current_season: Season = Season.SUMMER;

enum DeathReason { VOID, NO_HEALTH };

enum ProjectileSpeed {
	PROJECTILE_SPEED_FAST = 500,
	PROJECTILE_SPEED_VERY_SLOW = 75,
	PROJECTILE_SPEED_STATIC = 0,
}

enum CharacterSpeed {
	CHARACTER_SPEED_FAST = 500,
	CHARACTER_SPEED_MEDIUM = 300,
	CHARACTER_SPEED_STATIC = 0
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
	
var DAMAGE_AND_APPEAR_ON_COLLIDE = func(projectile: Projectile, body: Node2D) -> void:
	if body is Player:
		(body as Player).stats.health -= 10;
	(projectile.get_node("AnimatedSprite2D") as AnimatedSprite2D).play("display");

var EXPLODE_ON_COLLIDE = func(projectile: Projectile, body: Node2D) -> void:
	DAMAGE_ON_COLLIDE.call(projectile, body);


var PROJECTILES_DATA: Dictionary[String, ProjectileData] = {
	"camelia_missile": ProjectileData.new(
		preload("res://resources/projectiles/camelia_missile_sprite_frames.tres"),
		preload("res://resources/projectiles/camelia_missile_shape.tres"),
		ProjectileSpeed.PROJECTILE_SPEED_FAST,
		EXPLODE_ON_COLLIDE
	),
	"muguet_sword": ProjectileData.new(
		preload("res://resources/projectiles/muguet_hit_sprite_frames.tres"),
		preload("res://resources/projectiles/muguet_hit_collision.tres"),
		ProjectileSpeed.PROJECTILE_SPEED_VERY_SLOW,
		DAMAGE_AND_APPEAR_ON_COLLIDE,
		0.5
	),
	"sauge_leaf": ProjectileData.new(
		preload("res://resources/projectiles/sauge_leaf_sprite_frames.tres"),
		preload("res://resources/projectiles/sauge_leaf_shape.tres"),
		ProjectileSpeed.PROJECTILE_SPEED_FAST,
		DAMAGE_ON_COLLIDE
	),
}

var CHARACTERS_DATA: Dictionary[String, CharacterData] = {
	"sauge": CharacterData.new(
		"Sauge",
		"sauge_leaf",
		preload("res://resources/characters/sauge_sprite_frames.tres"),
		preload("res://resources/characters/sauge_collision_shape.tres"),
		CharacterStats.new(120, CharacterSpeed.CHARACTER_SPEED_MEDIUM, JumpStrength.JUMP_STRENGTH_MEDIUM, Gravity.GRAVITY_HIGH)
	),
	"muguet": CharacterData.new(
		"Muguet",
		"muguet_sword",
		preload("res://resources/characters/muguet_sprite_frames.tres"),
		preload("res://resources/characters/muguet_collision_shape.tres"),
		CharacterStats.new(80, CharacterSpeed.CHARACTER_SPEED_FAST, JumpStrength.JUMP_STRENGTH_HIGH, Gravity.GRAVITY_MEDIUM),
		Vector2(0, -70)
	),
}

var MAP_DATA: Dictionary[String, MapData] = {
	"mountains": MapData.new(
		"Mountains",
		preload("res://maps/mountains_map.tscn"),
		{
			Season.SPRING: preload("res://assets/backgrounds/seasons/spring.png"),
			Season.SUMMER: preload("res://assets/backgrounds/seasons/summer.png"),
			Season.AUTUMN: preload("res://assets/backgrounds/seasons/autumn.png"),
			Season.WINTER: preload("res://assets/backgrounds/seasons/winter.png"),
		}
	)
}

var SEASONS_DATA: Dictionary[Season, SeasonData] = {
	Season.SPRING: SeasonData.new(
		preload("res://assets/sounds/spring.mp3")
	),
	Season.SUMMER: SeasonData.new(
		preload("res://assets/sounds/summer.mp3")
	),
	Season.AUTUMN: SeasonData.new(
		preload("res://assets/sounds/autumn.mp3")
	),
	Season.WINTER: SeasonData.new(
		preload("res://assets/sounds/winter.mp3")
	),
}

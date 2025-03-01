extends Node

enum DeathReason { VOID, NO_HEALTH };

const PROJECTILE_SPEED_FAST: int = 500

var PROJECTILES_DATA: Dictionary = {
	"camelia_missile": ProjectileData.new(
		preload("res://resources/projectiles/camelia_missile_sprite_frames.tres"),
		preload("res://resources/projectiles/camelia_missile_shape.tres"),
		PROJECTILE_SPEED_FAST
	),
}

var CHARACTERS_DATA: Dictionary = {
	"cyclamen": CharacterData.new("Cyclamen", preload("res://resources/characters/cyclamen_sprite_frames.tres")),
	"camelia": CharacterData.new("Camelia", preload("res://resources/characters/camelia_sprite_frames.tres")),
}

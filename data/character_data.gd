class_name CharacterData
extends Resource

var display_name: String
var sprite_frames: SpriteFrames
# INPUT: String
var attacks: Dictionary

func _init(name: String, sprite: SpriteFrames, ) -> void:
	display_name = name
	sprite_frames = sprite

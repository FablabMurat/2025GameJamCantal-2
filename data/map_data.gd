class_name MapData
extends Object

var display_name: String;
var scene: PackedScene;
var backgrounds: Dictionary[Data.Season, Texture];

func _init(name: String, packed_scene: PackedScene, season_backgrounds: Dictionary[Data.Season, Texture]) -> void:
	display_name = name;
	scene = packed_scene;
	backgrounds = season_backgrounds;

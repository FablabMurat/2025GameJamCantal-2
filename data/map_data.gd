class_name MapData
extends Object

var display_name: String;
var backgrounds: Dictionary[Data.Season, Texture];

func _init(name: String, season_backgrounds: Dictionary[Data.Season, Texture]) -> void:
	display_name = name;
	backgrounds = season_backgrounds;

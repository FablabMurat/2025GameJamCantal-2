extends Node2D

func _ready() -> void:
	if Data.current_season == Data.Season.WINTER:
		get_node("MainIsland/MainIslandGrass").hide();
		get_node("SmallIsland/SmallIslandGrass").hide();
	else:
		get_node("MainIsland/MainIslandSnow").hide();
		get_node("SmallIsland/SmallIslandSnow").hide();

class_name World
extends Node2D

enum Hazard{NONE, RAIN}

func _on_hazard_timer_timeout() -> void:
	var new_material = ShaderMaterial.new()
	var hazard = randi() % (Hazard.size() + 1);
	if hazard == Hazard.RAIN:
		if Data.current_season == Data.Season.WINTER:
			new_material.shader = preload("res://resources/shaders/snow.gdshader")
		else:
			new_material.shader = preload("res://resources/shaders/rain.gdshader")
	$ShaderSurface.material = new_material;

class_name World
extends StaticBody2D

enum Hazard{NONE, RAIN}
enum Season{SUMMER, AUTUMN, WINTER, SPRING}

var season: Season = Season.WINTER;


func _on_hazard_timer_timeout() -> void:
	var new_material = ShaderMaterial.new()
	var hazard = randi() % Hazard.size()+200;
	if hazard == Hazard.RAIN:
		if season == Season.WINTER:
			new_material.shader = preload("res://resources/shaders/snow.gdshader")
		else:
			new_material.shader = preload("res://resources/shaders/rain.gdshader")
	$ShaderSurface.material = new_material;

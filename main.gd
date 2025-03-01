extends Node2D

# device ID to Player map
var DEVICES_MAP: Dictionary = {};
var new_id = 1;

func _unhandled_input(event: InputEvent) -> void:
	if DEVICES_MAP.has(event.device):
		(DEVICES_MAP[event.device] as Player).handle_input(event);
	else:
		var new_player: Player = init_player(new_id);
		new_id += 1;
		
		DEVICES_MAP[event.device] = new_player;

func init_player(id: int) -> Player:
	var player = preload("res://player.tscn").instantiate()
	player.init_character("camelia")
	player.id = id
	add_child(player);
	player.position.x = 50
	player.position.y = 18
	return player;

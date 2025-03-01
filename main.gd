extends Node2D

# device ID to Player map
var DEVICES_MAP: Dictionary = {};
var new_id = 1;

var round_running: bool = false;

signal player_join(device: int);

func _ready() -> void:
	start_game(false);
	player_join.connect(update_selection_ui)
	
func start_game(toggle: bool = true) -> void:
	$World.visible = toggle;
	$Gui/InFightGui.visible = toggle;
	$Gui/OutFightGui.visible = !toggle;
	$World.set_process(toggle);
	$World.set_physics_process(toggle);

func _unhandled_input(event: InputEvent) -> void:
	if DEVICES_MAP.has(event.device):
		if round_running:
			(DEVICES_MAP[event.device] as Player).handle_game_input(event);
	elif (event is InputEventJoypadButton and (event as InputEventJoypadButton).button_index==JOY_BUTTON_START and (event as InputEventJoypadButton).pressed):
		if !round_running:
			var new_player: Player = init_player(new_id);
			new_id += 1;
			DEVICES_MAP[event.device] = new_player;
			player_join.emit(event.device)

func update_selection_ui(device: int) -> void:
	var selector := AnimatedSprite2D.new();
	selector.sprite_frames = (Data.CHARACTERS_DATA.values()[0] as CharacterData).sprite_frames;
	selector.play("idle");
	$Gui/OutFightGui/PlayerSelector.add_child(selector)

func update_combat_ui() -> void:
	$Gui/InFightGui/RichTextLabel.text = ""
	for player in DEVICES_MAP.values():
		$Gui/InFightGui/RichTextLabel.add_text("Player %d: %d HP\n" % [(player as Player).id, (player as Player).stats.health]);
		

var current_character: int = 0

func init_player(id: int) -> Player:
	var player = preload("res://player.tscn").instantiate()
	player.id = id
	add_child(player);
	player.position.x = 50
	player.position.y = 18
	return player;

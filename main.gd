extends Node2D

# device ID to Player map
var DEVICES_MAP: Dictionary = {};
var new_id = 1;

var round_running: bool = false;

signal player_join(device: int);

func _ready() -> void:
	start_game(false);
	player_join.connect(add_to_selection_ui)
	
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
		else:
			if event is InputEventJoypadButton and (event as InputEventJoypadButton).button_index==JOY_BUTTON_DPAD_RIGHT and (event as InputEventJoypadButton).pressed:
				(DEVICES_MAP[event.device] as Player).selected_character = ((DEVICES_MAP[event.device] as Player).selected_character + 1) % Data.CHARACTERS_DATA.size();
				update_selection_ui()
			elif event is InputEventJoypadButton and (event as InputEventJoypadButton).button_index==JOY_BUTTON_DPAD_LEFT and (event as InputEventJoypadButton).pressed:
				(DEVICES_MAP[event.device] as Player).selected_character = ((DEVICES_MAP[event.device] as Player).selected_character - 1) % Data.CHARACTERS_DATA.size();
				update_selection_ui()
	elif (event is InputEventJoypadButton and (event as InputEventJoypadButton).button_index==JOY_BUTTON_START and (event as InputEventJoypadButton).pressed):
		if !round_running:
			var new_player: Player = init_player(new_id);
			new_id += 1;
			DEVICES_MAP[event.device] = new_player;
			player_join.emit(event.device)

func add_to_selection_ui(device: int) -> void:
	var selector_container := HBoxContainer.new();
	var selector := AnimatedSprite2D.new();
	selector.sprite_frames = (Data.CHARACTERS_DATA.values()[0] as CharacterData).sprite_frames;
	selector.play("idle");
	selector.name = str(device);
	$Gui/OutFightGui/PlayerSelector.add_child(selector);
	update_selection_ui()

func update_selection_ui() -> void:
	var player_count: int = $Gui/OutFightGui/PlayerSelector.get_child_count();
	var i: int = 0;
	for child in $Gui/OutFightGui/PlayerSelector.get_children():
		(child as AnimatedSprite2D).sprite_frames = (Data.CHARACTERS_DATA.values()[(DEVICES_MAP[int((child.name as StringName).c_escape())] as Player).selected_character] as CharacterData).sprite_frames;
		(child as AnimatedSprite2D).play("idle");
		child.position = Vector2(960 + ((-player_count/2 + i ) * 300), 400);
		i+=1;

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

class_name Main
extends Node2D

var DEVICES_MAP: Dictionary[int, Player] = {};

var round_running: bool = false;
var current_season: Data.Season = Data.Season.SUMMER;

signal player_join(device: int);
signal players_ready;
signal change_season;

func _ready() -> void:
	start_game(false);
	player_join.connect(add_to_selection_ui);
	players_ready.connect(start_game);
	update_selection_ui();
	
func start_game(toggle: bool = true) -> void:
	$World.visible = toggle;
	$Gui/InFightGui.visible = toggle;
	$Gui/OutFightGui.visible = !toggle;
	$World.set_process(toggle);
	$World.set_physics_process(toggle);
	round_running = toggle;
	if toggle:
		for device in DEVICES_MAP:
			var player: Player = DEVICES_MAP[device];
			player.init_character(Data.CHARACTERS_DATA.keys()[player.selected_character]);
			player.position.x = 300 * (device+1);
			player.position.y = 0;
			player.show();
			player.locked_character = false;
		update_selection_ui()
	else:
		for device in DEVICES_MAP:
			var player: Player = DEVICES_MAP[device];
			player.hide()


func _unhandled_input(event: InputEvent) -> void:
	if DEVICES_MAP.has(event.device):
		if round_running:
			(DEVICES_MAP[event.device] as Player).handle_game_input(event);
		else:
			if event is InputEventJoypadButton:
				var input: InputEventJoypadButton = event as InputEventJoypadButton;
				var player: Player = DEVICES_MAP[event.device] as Player;
				if input.button_index == JOY_BUTTON_START and input.pressed:
					DEVICES_MAP.erase(event.device);
					remove_from_selection_ui(event.device);
				elif input.button_index==JOY_BUTTON_DPAD_RIGHT and input.pressed:
					if player.locked_character:
						pass
					else:
						player.selected_character = (player.selected_character + 1) % Data.CHARACTERS_DATA.size();
						update_selection_ui();
				elif input.button_index==JOY_BUTTON_DPAD_LEFT and input.pressed:
					if player.locked_character:
						pass
					else:
						player.selected_character = (player.selected_character - 1) % Data.CHARACTERS_DATA.size();
						update_selection_ui();
				elif input.button_index==JOY_BUTTON_BACK and input.pressed:
					player.locked_character = !player.locked_character;
					update_selection_ui()
	elif (event is InputEventJoypadButton and (event as InputEventJoypadButton).button_index==JOY_BUTTON_START and (event as InputEventJoypadButton).pressed):
		if !round_running:
			var new_player: Player = init_player(event.device);
			DEVICES_MAP[event.device] = new_player;
			player_join.emit(event.device)

func add_to_selection_ui(device: int) -> void:
	var selector := AnimatedSprite2D.new();
	var character_data: CharacterData = Data.CHARACTERS_DATA.values()[0];
	selector.sprite_frames = character_data.sprite_frames;
	selector.play("idle");
	selector.name = str(device);
	selector.material = ShaderMaterial.new()
	
	var selector_label: Label = Label.new();
	selector_label.text = character_data.display_name;
	selector_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER;
	selector_label.scale = Vector2(2, 2);
	selector.add_child(selector_label);
	$Gui/OutFightGui/PlayerSelector.add_child(selector);
	update_selection_ui()

func remove_from_selection_ui(device: int) -> void:
	var selector_ind: int = $Gui/OutFightGui/PlayerSelector.get_children().find_custom(func(child: AnimatedSprite2D): return child.name==str(device));
	print(selector_ind)
	if selector_ind != -1:
		var selector: AnimatedSprite2D = $Gui/OutFightGui/PlayerSelector.get_child(selector_ind);
		selector.free();
	update_selection_ui();

func update_selection_ui() -> void:
	var player_count: int = $Gui/OutFightGui/PlayerSelector.get_child_count();
	var ready_player_count: int = 0;
	var i: int = 0;
	var highlight_shader: Shader = preload("res://resources/shaders/highlight.gdshader");
	print(DEVICES_MAP)
	for child in ($Gui/OutFightGui/PlayerSelector.get_children() as Array[AnimatedSprite2D]):
		var player: Player = DEVICES_MAP[int((child.name as StringName).c_escape())] as Player;
		var character_data: CharacterData = Data.CHARACTERS_DATA.values()[player.selected_character];
		(child as AnimatedSprite2D).sprite_frames = character_data.sprite_frames;
		(child as AnimatedSprite2D).play("idle");
		
		var label: Label = child.get_children()[0];
		label.position = Vector2(-100, 500);
		
		if player.locked_character:
			ready_player_count += 1;
			((child as AnimatedSprite2D).material as ShaderMaterial).shader = highlight_shader.duplicate();
			((child as AnimatedSprite2D).material as ShaderMaterial).set_shader_parameter("variation", Time.get_ticks_msec());
			label.text = "%s"%character_data.display_name;
		else:
			((child as AnimatedSprite2D).material as ShaderMaterial).shader = null
			label.text = "<- %s ->"%character_data.display_name;
		child.position = Vector2(960 + ((-float(player_count)/2 + i ) * 300) + 150, 400);
		
		i+=1;
	if player_count == 0:
		$Gui/OutFightGui/JoinLabel.text = "Select your plant !\nPress <START> to join\nMissing 2 players to start...";
		$Gui/OutFightGui/JoinLabel.position.y = 900;
	elif player_count == 1:
		$Gui/OutFightGui/JoinLabel.text = "Select your plant !\nPress <START> to join\nMissing a player to start...";
		$Gui/OutFightGui/JoinLabel.position.y = 900;
	else:
		$Gui/OutFightGui/JoinLabel.text = "Select your plant !\nPress <START> to join";
		$Gui/OutFightGui/JoinLabel.position.y = 960;
		if ready_player_count == player_count:
			$Gui/OutFightGui/LockLabel.text = "Press <SELECT> to (un)lock your character";
			$Gui/OutFightGui/LockLabel.position.y = 1020;
			players_ready.emit()
	if ready_player_count != player_count:
		$Gui/OutFightGui/LockLabel.text = "Press <SELECT> to (un)lock your character\n%d player(s) not ready" % (player_count - ready_player_count);
		$Gui/OutFightGui/LockLabel.position.y = 960;
		

func update_combat_ui() -> void:
	$Gui/InFightGui/RichTextLabel.text = ""
	for player in DEVICES_MAP.values():
		$Gui/InFightGui/RichTextLabel.add_text("Player %d: %d HP\n" % [(player as Player).id, (player as Player).stats.health]);
	

var current_character: int = 0

func player_death(player: Player, _reason: Data.DeathReason):
	player.dead = true;
	var alive_players = DEVICES_MAP.values().filter(func(p: Player): return !p.dead);
	print(alive_players)
	if alive_players.size() <= 1:
		start_game(false);

func init_player(id: int) -> Player:
	var player = preload("res://player.tscn").instantiate()
	player.death.connect(player_death)
	player.id = id
	add_child(player);
	player.position.x = 50
	player.position.y = 18
	return player;

class_name Main
extends Node2D

var DEVICES_MAP: Dictionary[int, Player] = {};

var round_running: bool = false;

var GAME_RUNNING: bool = false;

var current_map_node: Node2D;

signal player_join(device: int);
signal players_ready;

func _ready() -> void:
	$Gui/BeforeStartMenu/MainMenuAnimation.play("default");
	$Gui/OutFightGui/CharacterSelectionMenuAnimation.play("default");
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
		Data.current_season = Data.Season.get(Data.Season.keys().pick_random());
		var map_data: MapData = (Data.MAP_DATA["mountains"] as MapData);
		$World/Background.texture = map_data.backgrounds.get(Data.current_season);
		current_map_node = map_data.scene.instantiate();
		$World.add_child(current_map_node);
		$World/AudioStreamPlayer.stream = Data.SEASONS_DATA[Data.current_season].music;
		$World/AudioStreamPlayer.volume_db = -50;
		$World/AudioStreamPlayer.play()
		var tween: Tween = create_tween();
		tween.tween_property($World/AudioStreamPlayer, "volume_db", 0.0, 10.0);
		if $World/AudioStreamPlayer.stream is AudioStreamMP3:
			($World/AudioStreamPlayer.stream as AudioStreamMP3).loop = true;
		for device in DEVICES_MAP:
			var player: Player = DEVICES_MAP[device];
			player.position.x = 300 * (device+1);
			player.position.y = 0;
			player.show();
			player.locked_character = false;
		update_selection_ui()
	else:
		for node in get_tree().get_nodes_in_group("projectiles"):
			node.queue_free();
		if current_map_node != null:
			current_map_node.queue_free();
		var tween: Tween = create_tween();
		tween.tween_property($World/AudioStreamPlayer, "volume_db", -100.0, 3.0);
		tween.finished.connect($World/AudioStreamPlayer.stop);
		for device in DEVICES_MAP:
			var player: Player = DEVICES_MAP[device];
			player.hide()


func _unhandled_input(event: InputEvent) -> void:
	if !GAME_RUNNING:
		if !(event is InputEventJoypadButton and (event as InputEventJoypadButton).button_index==JOY_BUTTON_START and event.is_pressed()):
			return;
		else:
			GAME_RUNNING = true;
			$Gui/BeforeStartMenu.hide();
			var new_player: Player = init_player(event.device);
			DEVICES_MAP[event.device] = new_player;
			player_join.emit(event.device)
	elif DEVICES_MAP.has(event.device):
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
	selector.scale = Vector2(0.5, 0.5);
	var character_data: CharacterData = Data.CHARACTERS_DATA.values()[0];
	selector.sprite_frames = character_data.sprite_frames;
	selector.play("idle");
	selector.name = str(device);
	selector.material = ShaderMaterial.new()
	
	var selector_label: Label = Label.new();
	selector_label.text = character_data.display_name;
	selector_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER;
	selector_label.label_settings = LabelSettings.new()
	selector_label.label_settings.font_color = Color.DARK_OLIVE_GREEN;
	selector_label.scale = Vector2(2, 2);
	selector.add_child(selector_label);
	$Gui/OutFightGui/PlayerSelector.add_child(selector);
	update_selection_ui()

func remove_from_selection_ui(device: int) -> void:
	var selector_ind: int = $Gui/OutFightGui/PlayerSelector.get_children().find_custom(func(child: AnimatedSprite2D): return child.name==str(device));
	if selector_ind != -1:
		var selector: AnimatedSprite2D = $Gui/OutFightGui/PlayerSelector.get_child(selector_ind);
		selector.free();
	update_selection_ui();

func update_selection_ui() -> void:
	var player_count: int = $Gui/OutFightGui/PlayerSelector.get_child_count();
	var ready_player_count: int = 0;
	var i: int = 0;
	var highlight_shader: Shader = preload("res://resources/shaders/highlight.gdshader");
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
		child.position = Vector2(960 + ((-float(player_count)/2 + i ) * 300) + 150, 550);
		
		i+=1;
	if player_count == 0:
		$Gui/OutFightGui/JoinLabel.text = "Missing 2 players to start...";
		GAME_RUNNING = false;
		$Gui/BeforeStartMenu.show();
	elif player_count == 1:
		$Gui/OutFightGui/JoinLabel.text = "Missing a player to start...";
	else:
		$Gui/OutFightGui/JoinLabel.text = "";
		if ready_player_count == player_count:
			$Gui/OutFightGui/LockLabel.text = "";
			players_ready.emit()
	if ready_player_count != player_count:
		$Gui/OutFightGui/LockLabel.text = "%d player(s) not ready" % (player_count - ready_player_count);
		

func update_combat_ui() -> void:
	$Gui/InFightGui/RichTextLabel.text = ""
	for player in DEVICES_MAP.values():
		$Gui/InFightGui/RichTextLabel.add_text("Player %d: %d HP\n" % [(player as Player).id, (player as Player).stats.health]);
	

func player_death(player: Player, _reason: Data.DeathReason):
	player.dead = true;
	var alive_players = DEVICES_MAP.values().filter(func(p: Player): return !p.dead);
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

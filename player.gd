class_name Player
extends CharacterBody2D

signal death(player: Player, reason: Data.DeathReason);
var dead: bool = false;

var id: int;

var left_joystick_direction: Vector2 = Vector2.ZERO;
var target_velocity: Vector2 = Vector2.ZERO;
var facing = 0;
var try_jump: bool = false
var running: bool = false

var selected_character: int = 0;
var locked_character: bool = false;
var character_data: CharacterData;
var stats: CharacterStats;

func init_character(character_id: String):
	character_data = (Data.CHARACTERS_DATA.get(character_id) as CharacterData);
	stats = character_data.stats.duplicate(true);
	stats.health_change.connect(health_update);
	dead = false;
	try_jump = false;
	velocity = Vector2(0,0);
	left_joystick_direction = Vector2(0,0);
	$WorldCollision.shape = character_data.collision_shape;
	$AnimatedSprite2D.sprite_frames = character_data.sprite_frames;
	$AnimatedSprite2D.offset = character_data.sprite_offset
	$AnimatedSprite2D.play("idle")

func _ready() -> void:
	print("Player %d joins the fight"%id);
	death.connect(handle_death)

func handle_game_input(event: InputEvent):
	if event is InputEventJoypadMotion:
		if (event as InputEventJoypadMotion).axis == JOY_AXIS_LEFT_X:
			left_joystick_direction.x = (event as InputEventJoypadMotion).axis_value
		if (event as InputEventJoypadMotion).axis == JOY_AXIS_LEFT_Y:
			left_joystick_direction.y = (event as InputEventJoypadMotion).axis_value
	if (event is InputEventJoypadButton):
		if (event as InputEventJoypadButton).button_index == JOY_BUTTON_A:
			try_jump = event.pressed;
		if (event as InputEventJoypadButton).button_index == JOY_BUTTON_X:
			running = event.pressed;
		if (event as InputEventJoypadButton).button_index == JOY_BUTTON_B && event.pressed:
			$AnimatedSprite2D.play("attack");
			var projectile = preload("res://projectile.tscn").instantiate();
			projectile.init_projectile(character_data.attack);
			projectile.position = position;
			(projectile.get_node("AnimatedSprite2D") as AnimatedSprite2D).flip_h = $AnimatedSprite2D.flip_h;
			projectile.thrower = self;
			get_parent().add_child(projectile);

func _physics_process(delta):
	if dead or !(get_parent() as Main).round_running:
		return;
	var on_floor = is_on_floor();
	
	if not on_floor:
		$AnimatedSprite2D.play("jump");
		velocity.y += stats.gravity * delta
	
	if abs(left_joystick_direction.x) > 0.2:
		velocity.x = left_joystick_direction.x * stats.speed * (1.5 if running and on_floor else 1.0)
		
		if on_floor:
			$AnimatedSprite2D.play("walk");
		facing = velocity.x;
		$AnimatedSprite2D.flip_h = facing < 0;
	else:
		velocity.x = velocity.x / 1.2;
		facing = 0;
		if on_floor and !($AnimatedSprite2D.is_playing() and $AnimatedSprite2D.animation=="attack"):
			$AnimatedSprite2D.play("idle");

	
	if try_jump and on_floor:
		velocity.y = -stats.jump_strength;
	move_and_slide();

func health_update():
	if stats.health <= 0:
		death.emit(self, Data.DeathReason.NO_HEALTH);

func handle_death(_player: Player, _reason: Data.DeathReason):
	dead = true;
	stats.health = character_data.stats.health;

func _on_exit_screen() -> void:
	death.emit(self, Data.DeathReason.VOID);

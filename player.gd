class_name Player
extends CharacterBody2D

signal death(reason: Data.DeathReason)

var id: int;

var left_joystick_direction: Vector2 = Vector2.ZERO;
var target_velocity: Vector2 = Vector2.ZERO;
var facing = 0;
var try_jump: bool = false
var running: bool = false

var base_stats: CharacterStats
var stats: CharacterStats

func init_character(character_id: String):
	var data: CharacterData = (Data.CHARACTERS_DATA.get(character_id) as CharacterData);
	base_stats = data.stats;
	stats = base_stats.duplicate();
	$WorldCollision.shape = data.collision_shape;
	$AnimatedSprite2D.sprite_frames = data.sprite_frames;
	$AnimatedSprite2D.offset = data.sprite_offset
	$AnimatedSprite2D.play("idle")

func _ready() -> void:
	print("Player %d joins the fight"%id);
	death.connect(handle_death)

func handle_input(event: InputEvent):
	if event is InputEventJoypadMotion:
		if (event as InputEventJoypadMotion).axis == JOY_AXIS_LEFT_X:
			left_joystick_direction.x = (event as InputEventJoypadMotion).axis_value
		if (event as InputEventJoypadMotion).axis == JOY_AXIS_LEFT_Y:
			left_joystick_direction.y = (event as InputEventJoypadMotion).axis_value
		#print(left_joystick_direction)
	if (event is InputEventJoypadButton):
		if (event as InputEventJoypadButton).button_index == JOY_BUTTON_A:
			try_jump = event.pressed;
		if (event as InputEventJoypadButton).button_index == JOY_BUTTON_X:
			running = event.pressed;
		if (event as InputEventJoypadButton).button_index == JOY_BUTTON_B && event.pressed:
			$AnimatedSprite2D.play("attack")
			var projectile = preload("res://projectile.tscn").instantiate();
			projectile.init_projectile("camelia_missile")
			projectile.position = position;
			(projectile.get_node("AnimatedSprite2D") as AnimatedSprite2D).flip_h = $AnimatedSprite2D.flip_h
			projectile.thrower = self;
			get_parent().add_child(projectile);

func _physics_process(delta):
	var on_floor = is_on_floor();
	
	if not on_floor:
		$AnimatedSprite2D.play("jump");
		velocity.y += stats.gravity * delta
	
	if abs(left_joystick_direction.x) > 0.2:
		velocity.x = left_joystick_direction.x * stats.speed * (1.5 if running and on_floor else 1)
		
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

func handle_death(reason: Data.DeathReason):
	velocity = Vector2(0, 0);
	position = Vector2(50, 18);
	stats.health = base_stats.health;

func _on_exit_screen() -> void:
	death.emit(Data.DeathReason.VOID);

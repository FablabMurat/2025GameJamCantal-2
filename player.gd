class_name Player
extends CharacterBody2D

signal death(reason: Data.DeathReason)

# Vertical impulse applied to the character upon jumping
@export var JUMP_IMPULSE = -400
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity");

var id: int;

var left_joystick_direction: Vector2 = Vector2.ZERO;
var target_velocity: Vector2 = Vector2.ZERO;
var facing = 0;
var try_jump: bool = false

var base_stats: CharacterStats
var stats: CharacterStats

func init_character(character_id: String):
	var data: CharacterData = (Data.CHARACTERS_DATA.get(character_id) as CharacterData);
	base_stats = data.stats;
	stats = base_stats.duplicate();
	$WorldCollision.shape = data.collision_shape;
	$AnimatedSprite2D.sprite_frames = data.sprite_frames;
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
		if (event as InputEventJoypadButton).button_index == JOY_BUTTON_X && event.pressed:
			var projectile = preload("res://projectile.tscn").instantiate();
			projectile.init_projectile("camelia_missile")
			projectile.position = position;
			(projectile.get_node("AnimatedSprite2D") as AnimatedSprite2D).flip_h = $AnimatedSprite2D.flip_h
			projectile.thrower = self;
			get_parent().add_child(projectile);

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if abs(left_joystick_direction.x) > 0.2:
		velocity.x = left_joystick_direction.x * stats.speed
		if abs(velocity.x) < 0.01:
			facing = 0;
			$AnimatedSprite2D.play("idle");
		else:
			$AnimatedSprite2D.play("walk");
			facing = velocity.x;
			$AnimatedSprite2D.flip_h = facing < 0;
	else:
		velocity.x = velocity.x / 1.2;
	
	if try_jump and is_on_floor():
		velocity.y = JUMP_IMPULSE;
	move_and_slide();

func handle_death(reason: Data.DeathReason):
	velocity = Vector2(0, 0);
	position = Vector2(50, 18);
	stats.health = base_stats.health;

func _on_exit_screen() -> void:
	death.emit(Data.DeathReason.VOID);

class_name Projectile
extends Area2D

var projectile_data: ProjectileData

func init_projectile(name: String) -> void:
	projectile_data = (Data.PROJECTILES_DATA.get(name) as ProjectileData);
	$CollisionShape2D.shape = projectile_data.collision_shape;
	$AnimatedSprite2D.sprite_frames = projectile_data.sprite_frames;
	$AnimatedSprite2D.play();

func _ready() -> void:
	print("Spawned projectile");

func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	position.x += (-1 if $AnimatedSprite2D.flip_h else 1) * projectile_data.speed * delta


func _on_exit_screen() -> void:
	queue_free()

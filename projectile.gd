class_name Projectile
extends Area2D

var projectile_data: ProjectileData
var thrower: Node2D

var time: float = 0

func init_projectile(projectile_name: String) -> void:
	projectile_data = (Data.PROJECTILES_DATA.get(projectile_name) as ProjectileData);
	$CollisionShape2D.shape = projectile_data.collision_shape;
	$AnimatedSprite2D.sprite_frames = projectile_data.sprite_frames;
	$AnimatedSprite2D.play();

func expire():
	print("Expired !")
	queue_free();

func _on_body_entered(body: Node2D) -> void:
	if body != thrower:
		projectile_data.collision_handler.call(self, body);
	
func _physics_process(delta: float) -> void:
	time += delta;
	position.x += (-1 if $AnimatedSprite2D.flip_h else 1) * projectile_data.speed * delta
	if projectile_data.lifetime > 0 and time >= projectile_data.lifetime:
		expire()


func _on_exit_screen() -> void:
	queue_free()

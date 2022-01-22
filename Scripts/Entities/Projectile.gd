extends Node2D

var path_to_scene = "res://Scenes/Entities/Projectiles/Bullet.tscn"
var velocity = Vector2()


func _process(delta):
	position += velocity * delta


func _on_Hitbox_body_entered(body):
	if "Enemy" in body.name:
		body.hurt(1)
		queue_free()

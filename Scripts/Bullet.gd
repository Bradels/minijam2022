extends Node2D

var velocity = Vector2()
onready var _sprite = $AnimatedSprite

func _process(delta):
	position += velocity * delta


func _on_Hitbox_body_entered(body):
	if "Enemy" in body.name:
		velocity = Vector2()
		_sprite.frame = 1
		_sprite.play()


func _on_AnimatedSprite_animation_finished():
	queue_free()

extends Node2D

onready var sound_byte = $SoundByte
var velocity = Vector2()


func _ready():
	sound_byte.play(0.0)


func _process(delta):
	position += velocity * delta
	
	if !sound_byte.playing && !visible:
		queue_free()

func _on_Hitbox_body_entered(body):
	if "Enemy" in body.name:
		visible = false
		body.hurt(1)

extends Node2D

var velocity = Vector2()
onready var scene_path = get_tree().current_scene.filename
onready var sound_byte = $SoundByte


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

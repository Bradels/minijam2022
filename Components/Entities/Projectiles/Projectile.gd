extends Node2D


var velocity = Vector2()
var id = ""
var owner_id = ""
onready var scene_path = get_tree().current_scene.filename
onready var sound_byte = $SoundByte
var projectile_max_life:float = 0.5
var bullet_alive_time:float = 0


func _ready():
	sound_byte.play(0.0)


func _process(delta):
	position += velocity * delta
	bullet_alive_time += delta
	
	if !sound_byte.playing && (!visible || bullet_alive_time >= projectile_max_life):
		queue_free()


func _on_Hitbox_body_entered(body):
	if !visible:
		return

	if "Enemy" in body.name:
		visible = false
		body.hurt(1)

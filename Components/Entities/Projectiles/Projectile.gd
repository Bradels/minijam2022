extends Node2D

signal entity_transform(transformed_values)
signal entity_prop_updated(prop,value)

var velocity = Vector2()
var id = ''
var owner_id = ""
onready var scene_path = get_tree().current_scene.filename
onready var Hitbox = $Hitbox
onready var SoundByte = $SoundByte
var projectile_max_life:float = 0.5
var bullet_alive_time:float = 0


func _ready():
	SoundByte.play(0.0)
	Hitbox.connect('body_entered', self, '_on_collision')


func _process(delta):
	position += velocity * delta
	bullet_alive_time += delta
	
	if !SoundByte.playing && (!visible || bullet_alive_time >= projectile_max_life):
		queue_free()


func _on_collision(body):
	if !visible:
		return
	
	if "Player" in body.name || "Spaceship" in body.name:
		return

	if "Enemy" in body.name:
		body.hurt(1)
		visible = false
	else:
		visible = false

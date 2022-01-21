extends KinematicBody2D

var move_speed = 256
var bullet_speed = 1024
var bullet = preload("res://Scenes/Bullet.tscn")

var current_time : float = 0
var fire_rate : float = 2
onready var bullet_delta : float = 1 / fire_rate

onready var _nozzle = $Nozzle
onready var _sprite = $AnimatedSprite

func _physics_process(_delta):
	var moving = false
	var motion = Vector2()
	motion.x = 0
	motion.y = 0

	if Input.is_action_pressed('up'):
		motion.y = -1
		moving = true

	if Input.is_action_pressed('down'):
		motion.y = 1
		moving = true
		
	if Input.is_action_pressed('left'):
		motion.x = -1
		moving = true
		
	if Input.is_action_pressed('right'):
		motion.x = 1
		moving = true
	
	if (moving):
		_sprite.play()
	else:
		_sprite.stop()
		_sprite.frame = 0

	motion = motion.normalized()
	motion = move_and_slide(motion * move_speed)
	
	look_at(get_global_mouse_position())


func _process(delta):
	current_time += delta
	if (current_time < bullet_delta):
		return

	if Input.is_action_pressed("fire"):
		current_time = 0
		fire()


func fire():
	var bullet_instance = bullet.instance()
	bullet_instance.position = _nozzle.global_position
	bullet_instance.rotation = rotation
	bullet_instance.velocity = Vector2(bullet_speed, 0).rotated(rotation)
	get_tree().get_root().call_deferred('add_child', bullet_instance)

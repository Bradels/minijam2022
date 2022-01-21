extends KinematicBody2D


var move_speed : int = 256
var bullet_speed : int = 1024
var bullet : PackedScene = preload("res://Scenes/Entities/Bullet.tscn")

var bullet_time : float = 0
var fire_rate : float = 2
onready var bullet_delta : float = 1 / fire_rate

var is_current : bool = false
var is_host : bool = false
onready var _camera : Camera2D = $Camera
onready var _nozzle : Node2D = $Nozzle
onready var _sprite : AnimatedSprite = $AnimatedSprite


func _physics_process(_delta):
	if !is_current:
		return
		
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


puppet func poopdate(position, rotation):
	shitdate(position, rotation)
	if is_host and !is_current:
		rpc_unreliable("shitdate", position, rotation)


puppet func shitdate(position, rotation):
	self.position = position
	self.rotation = rotation


func _process(delta):
	if _camera.current != is_current:
		_camera.current = is_current
	
	if is_current:
		rpc_unreliable("poopdate", position, rotation)
		
		bullet_time += delta
		if (bullet_time < bullet_delta):
			return
	
		if Input.is_action_pressed("fire"):
			bullet_time = 0
			fire()


puppetsync func fire():
	var bullet_instance = bullet.instance()
	bullet_instance.position = _nozzle.global_position
	bullet_instance.rotation = rotation
	bullet_instance.velocity = Vector2(bullet_speed, 0).rotated(rotation)
	get_tree().get_root().call_deferred('add_child', bullet_instance)

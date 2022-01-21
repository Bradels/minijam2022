extends KinematicBody2D

var move_speed = 256
var bullet_speed = 1024
var bullet = preload("res://Scenes/Entities/Bullet.tscn")

var current_time : float = 0
var fire_rate : float = 2
onready var bullet_delta : float = 1 / fire_rate

var current_player = false
var is_host = false
onready var _nozzle = $Nozzle
onready var _sprite = $AnimatedSprite


func _ready():
	$Camera.current = current_player

func _physics_process(_delta):
	if !current_player:
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
	if is_host and !current_player:
		rpc_unreliable("shitdate", position, rotation)
	self.position = position
	self.rotation = rotation

puppet func shitdate(position, rotation):
	self.position = position
	self.rotation = rotation


func _process(delta):
	if current_player:
		rpc_unreliable("poopdate", position, rotation)
		current_time += delta
		if (current_time < bullet_delta):
			return

		if Input.is_action_pressed("fire"):
			current_time = 0
			fire()


puppetsync func fire():
	var bullet_instance = bullet.instance()
	bullet_instance.position = _nozzle.global_position
	bullet_instance.rotation = rotation
	bullet_instance.velocity = Vector2(bullet_speed, 0).rotated(rotation)
	get_tree().get_root().call_deferred('add_child', bullet_instance)

extends KinematicBody2D


signal moved(position, rotation)

var move_speed : int = 256
var bullet_speed : int = 1024
var bullet : PackedScene = preload("res://Scenes/Entities/Bullet.tscn")

var bullet_time : float = 0
var fire_rate : float = 2
onready var bullet_delta : float = 1 / fire_rate

<<<<<<< HEAD:Scripts/Entities/Player.gd
var current_player = false
var is_host = false
onready var _nozzle = $Nozzle
onready var _sprite = $AnimatedSprite


func _ready():
	$Camera.current = current_player
	

func _physics_process(_delta):
	if current_player:
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
		
		NetworkManager.emit_signal("entity_moved", self)
		if motion.length() > 0:
			if is_host:
				rpc_unreliable("move_player", position, rotation)
			else:
				rpc_unreliable_id(1, "move_player", position, rotation)


remote func move_player(position, rotation):
	self.position = position
	self.rotation = rotation
	
	if is_host:
		rpc_unreliable("move_player", position, rotation)
	

func _process(delta):
	if current_player:
		current_time += delta
		if (current_time < bullet_delta):
=======
var is_current : bool = true
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

	if Input.is_action_pressed('pawn_up'):
		motion.y = -1
		moving = true

	if Input.is_action_pressed('pawn_down'):
		motion.y = 1
		moving = true
		
	if Input.is_action_pressed('pawn_left'):
		motion.x = -1
		moving = true
		
	if Input.is_action_pressed('pawn_right'):
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
	if _camera.current != is_current:
		_camera.current = is_current
	
	if is_current:
		emit_signal('moved', position, rotation)
		
		bullet_time += delta
		if (bullet_time < bullet_delta):
>>>>>>> 754daa72c0233f36d7cee012ba44e06a39229f8a:Scripts/Entities/Player/Player.gd
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

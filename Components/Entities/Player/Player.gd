extends KinematicBody2D


signal player_transform(player)
signal projectile_fired(projectile, props)

var fire_rate : float = 2
onready var bullet_delta : float = 1 / fire_rate
var bullet_speed : int = 1024
var bullet_time : float = 0
var move_speed : int = 256

onready var _camera = $Camera
onready var _nozzle = $Nozzle
onready var _sprite = $AnimatedSprite

var id = 0
var is_active = false


func _ready():
	_camera.current = is_active


func _physics_process(_delta):
	if is_active:
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
	_emit_transform()
	
	if is_active:
		if Input.is_action_pressed("pawn_fire"):
			fire(delta)


func _emit_transform():
	emit_signal('player_transform', self)


func fire(delta):
	bullet_time += delta
	
	if (bullet_time < bullet_delta):
		return
	
	bullet_time = 0
	emit_signal('projectile_fired', {
		'type': 'PAWN_PRIMARY',
		'owner_id': id,
		"position": _nozzle.global_position,
		"rotation": 	rotation,
		"velocity": Vector2(bullet_speed, 0).rotated(rotation),
	})

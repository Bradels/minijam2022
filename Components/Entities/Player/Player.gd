extends "res://Components/Entities/Entity.gd"

signal projectile_fired(projectile, props)

var fire_rate : float = 4
onready var bullet_delta : float = 1 / fire_rate
var bullet_speed : int = 1024
var bullet_time : float = 0
var move_speed : int = 256

export(Color) var ghost_color = Color(0.7,0.9,0.2,0.2)
var is_ghost

onready var _camera = $Camera
onready var _nozzle = $Nozzle
onready var _sprite = $AnimatedSprite

var health = 21


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
	if health <= 0:
		_make_ghost()
	if is_active:
		_elapse_time(delta)
		
		if Input.is_action_pressed("pawn_fire") and !is_ghost:
			fire()
			
		._process(delta)


func _elapse_time(delta):
	bullet_time += delta

func _make_ghost():
	if is_ghost:
		return
	emit_signal("entity_prop_updated",id,"is_ghost",true)
	is_ghost = true
	modulate = ghost_color

func fire():
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

func damage(amount):
	health -= amount
	emit_signal("entity_prop_updated",id,"health",amount)

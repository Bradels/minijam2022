extends KinematicBody2D


signal moved(position, rotation)
signal entity_updated(props)
signal entity_creates_entity(props)
signal entity_created(props)

var move_speed : int = 256
var bullet_speed : int = 1024
var bullet : PackedScene = preload("res://Scenes/Entities/Projectiles/Bullet.tscn")

var bullet_time : float = 0
var fire_rate : float = 2
onready var bullet_delta : float = 1 / fire_rate

var is_active_player = false
onready var _camera = $Camera
onready var _nozzle = $Nozzle
onready var _sprite = $AnimatedSprite

var networked_props = ["position","rotation"]


func _ready():
	if !get_tree().has_network_peer():
		is_active_player = true
	_camera.current = is_active_player


func _physics_process(_delta):
	if is_active_player:
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


func get_networked_values():
	var networked_values = {}
	for prop in networked_props:
		networked_values[prop] = self[prop]
	return networked_values

remote func network_entity_updated(props):
	if !is_active_player:
		for prop in props:
			print("print here for success")
			self[prop] = props[prop]
	
	if get_tree().get_rpc_sender_id() != 1:
		rpc_unreliable("network_entity_moved", props)




func _process(delta):
	if is_active_player:
		emit_signal("entity_updated",{
				"position":position,
				"rotation":rotation})
		bullet_time += delta
		if (bullet_time < bullet_delta):
			return
	
		if Input.is_action_pressed("pawn_fire"):
			bullet_time = 0
			fire()


func fire():
	var bullet_instance = bullet.instance()
	bullet_instance.position = _nozzle.global_position
	bullet_instance.rotation = rotation
	bullet_instance.velocity = Vector2(bullet_speed, 0).rotated(rotation)
	var bullet_props = {
		"position": bullet_instance.position,
		"rotation": bullet_instance.rotation,
		"velocity": bullet_instance.velocity,
		"scene_path": bullet_instance.scene_path
	}
	emit_signal("entity_creates_entity",bullet_props)
	get_tree().get_root().call_deferred('add_child', bullet_instance)

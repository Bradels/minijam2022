extends KinematicBody2D


signal moved(position, rotation)
signal player_updated(player,props)
signal entity_spawned(player,props)

var move_speed : int = 256
var bullet_speed : int = 1024
var bullet : PackedScene = preload("res://Scenes/Entities/Bullet.tscn")

var bullet_time : float = 0
var fire_rate : float = 2
onready var bullet_delta : float = 1 / fire_rate

var is_active_player = false
onready var _nozzle = $Nozzle
onready var _sprite = $AnimatedSprite

var networked_props = ["position","rotation"]


func _ready():
	if !get_tree().has_network_peer():
		is_active_player = true
	$Camera.current = is_active_player
	

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
		
		if motion.length() > 0:
			emit_signal("player_updated",self,get_networked_values())


func get_networked_values():
	var networked_values = {}
	for prop in networked_props:
		networked_values[prop] = self[prop]
	return networked_props

remote func network_entity_updated(props):
	if !is_active_player:
		for prop in props:
			print("print here for success")
			self[prop] = props[prop]
	
	if get_tree().get_rpc_sender_id() != 1:
		rpc_unreliable("network_entity_moved", props)




func _process(delta):
	if is_active_player:
		bullet_time += delta
		if (bullet_time < bullet_delta):
			return
	
		if Input.is_action_pressed("fire"):
			bullet_time = 0
			fire()


func fire():
	var bullet_instance = bullet.instance()
	bullet_instance.position = _nozzle.global_position
	bullet_instance.rotation = rotation
	bullet_instance.velocity = Vector2(bullet_speed, 0).rotated(rotation)
	emit_signal("entity_spawned",self,bullet)
	get_tree().get_root().call_deferred('add_child', bullet_instance)

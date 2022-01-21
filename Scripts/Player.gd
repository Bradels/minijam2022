extends KinematicBody2D

var move_speed = 256
var bullet_speed = 2048
var bullet = preload("res://Scenes/Bullet.tscn")

var current_time : float = 0
var fire_rate : float = 4
onready var bullet_delta : float = 1 / fire_rate

func _physics_process(delta):
	var motion = Vector2()
	motion.x = 0
	motion.y = 0

	if Input.is_action_pressed('up'):
		motion.y = -1

	if Input.is_action_pressed('down'):
		motion.y = 1
		
	if Input.is_action_pressed('left'):
		motion.x = -1
		
	if Input.is_action_pressed('right'):
		motion.x = 1
	
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
	bullet_instance.position = get_global_position()
	bullet_instance.rotation = rotation + (0.5 * PI)
	bullet_instance.velocity = Vector2(bullet_speed, 0).rotated(rotation)
	get_tree().get_root().call_deferred('add_child', bullet_instance)

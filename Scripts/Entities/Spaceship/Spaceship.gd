extends KinematicBody2D

var move_speed = 256
var bullet_speed = 1024
var bullet = preload("res://Scenes/Entities/Bullet.tscn")

var current_time : float = 0
var fire_rate : float = 2
onready var bullet_delta : float = 1 / fire_rate

onready var thrusters = $Thrusters

func _physics_process(_delta):
	thrusters.off()

	if Input.is_action_pressed('ship_forward'):
		thrusters.forward()

	if Input.is_action_pressed('ship_reverse'):
		thrusters.reverse()
		
	if Input.is_action_pressed('ship_rotate_left'):
		thrusters.rotate_left()
		
	if Input.is_action_pressed('ship_rotate_right'):
		thrusters.rotate_right()
		
	if Input.is_action_pressed('ship_strafe_left'):
		thrusters.strafe_left()
		
	if Input.is_action_pressed('ship_strafe_right'):
		thrusters.strafe_right()


func _process(delta):
	current_time += delta
	if (current_time < bullet_delta):
		return

	if Input.is_action_pressed("fire"):
		current_time = 0
		fire()


func fire():
	var bullet_instance = bullet.instance()
	bullet_instance.position = global_position
	bullet_instance.rotation = rotation
	bullet_instance.velocity = Vector2(bullet_speed, 0).rotated(rotation)
	get_tree().get_root().call_deferred('add_child', bullet_instance)

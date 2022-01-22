extends KinematicBody2D


onready var thrusters = $Thrusters
var primary_thrust = 256
var secondary_thrust = 128
var max_velocity = 512


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

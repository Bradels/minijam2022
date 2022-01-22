extends KinematicBody2D


onready var thrusters = $Thrusters
var primary_thrust : int = 256
var secondary_thrust : int = 128
var max_velocity : int = 512

var acceleration : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2.ZERO

func _physics_process(delta):
	thrusters.off()
	acceleration = Vector2.ZERO
		
	if Input.is_action_pressed('ship_rotate_left'):
		rotation -= secondary_thrust * delta * 0.02
		thrusters.rotate_left()
		
	if Input.is_action_pressed('ship_rotate_right'):
		rotation += secondary_thrust * delta * 0.02
		thrusters.rotate_right()

	if Input.is_action_pressed('ship_forward'):
		acceleration.x += primary_thrust
		thrusters.forward()

	if Input.is_action_pressed('ship_reverse'):
		acceleration.x -= secondary_thrust
		thrusters.reverse()
		
	if Input.is_action_pressed('ship_strafe_left'):
		acceleration.y -= secondary_thrust
		thrusters.strafe_left()
		
	if Input.is_action_pressed('ship_strafe_right'):
		acceleration.y += secondary_thrust
		thrusters.strafe_right()
		
	acceleration = acceleration.rotated(rotation)
	velocity += acceleration * delta
	position += move_and_slide(velocity * delta)

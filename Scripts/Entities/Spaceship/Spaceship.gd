extends KinematicBody2D


onready var thrusters = $Thrusters
onready var weapons = $Weapons

var acceleration : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2.ZERO
var max_velocity : int = 256
var thrust : int = 256


func _physics_process(delta):
	thrusters.off()
	acceleration = Vector2.ZERO
		
	if Input.is_action_pressed('ship_rotate_left'):
		rotation -= thrust * delta * 0.01
		thrusters.rotate_left()
		
	if Input.is_action_pressed('ship_rotate_right'):
		rotation += thrust * delta * 0.01
		thrusters.rotate_right()

	if Input.is_action_pressed('ship_forward'):
		acceleration.x += thrust
		thrusters.forward()

	if Input.is_action_pressed('ship_reverse'):
		acceleration.x -= thrust
		thrusters.reverse()
		
	if Input.is_action_pressed('ship_strafe_right'):
		acceleration.y += thrust
		thrusters.strafe_right()
		
	if Input.is_action_pressed('ship_strafe_left'):
		acceleration.y -= thrust
		thrusters.strafe_left()
	
	acceleration = acceleration.rotated(rotation)
	velocity += acceleration * delta
	position += move_and_slide(velocity * delta)


func _process(delta):
	weapons.elapse_time(delta)
	
	if Input.is_action_pressed('ship_fire_primary'):
		weapons.fire_primary()
	
	if Input.is_action_pressed('ship_fire_secondary'):
		weapons.fire_secondary()

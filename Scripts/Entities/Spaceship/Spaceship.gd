extends KinematicBody2D


onready var thrusters = $Thrusters
onready var weapons = $Weapons
onready var camera = $Camera
onready var hud = $Camera/Canvas/HUD

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
	
	hud.position(position)
	hud.speed(velocity.length())


func _process(delta):
	weapons.elapse_time(delta)
	
	if Input.is_action_pressed('ship_fire_primary'):
		weapons.fire_primary()
	
	if Input.is_action_pressed('ship_fire_secondary'):
		weapons.fire_secondary()


func _unhandled_input(event):
	if (event.is_action_pressed('zoom_in')):
		camera.zoom_in()
		
	if (event.is_action_pressed('zoom_out')):
		camera.zoom_out()

extends KinematicBody2D


onready var thrusters = $Thrusters
onready var weapons = $Weapons
onready var camera = $Camera
onready var hud = $Camera/Canvas/HUD

var acceleration : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2.ZERO
var max_velocity : int = 512
var primary_thrust : int = 256
var secondary_thrust : int = 128


func _ready():
	pass


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
		
	if Input.is_action_pressed('ship_strafe_right'):
		acceleration.y += secondary_thrust
		thrusters.strafe_right()
		
	if Input.is_action_pressed('ship_strafe_left'):
		acceleration.y -= secondary_thrust
		thrusters.strafe_left()
	
	acceleration = acceleration.rotated(rotation)
	velocity += acceleration * delta
	velocity = velocity.clamped(max_velocity)
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

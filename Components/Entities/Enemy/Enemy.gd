extends KinematicBody2D


signal died(id)


enum ENEMY_STATES { IDLE, FOLLOWING, CLAWING, SHOOTING, DYING }

var id = ''
var velocity = Vector2.ZERO
var nearest_player = null

onready var animation_player = $AnimationPlayer
onready var is_host = get_tree().get_network_unique_id() in [0, 1]

export(bool) var dead = false
export(int) var health = 2
export(int) var damage = 1
export(float) var speed = 48
export(float) var search_radius = 256
export(float) var attack_radius = 64


func _process(_delta):
	if dead:
		return

	set_nearest_player_or_null()
	
	match _determine_state():
		ENEMY_STATES.IDLE:
			idle()
		ENEMY_STATES.FOLLOWING:
			follow_player()
		ENEMY_STATES.CLAWING:
			attack()
		ENEMY_STATES.DYING:
			death()


func _physics_process(_delta):
	if is_host && !dead:
		velocity = move_and_slide(velocity)


func _set_velocity(new_velocity):
	if is_host && !dead:
		velocity = new_velocity


func _play_animation(name):
	var current = animation_player.current_animation
	
	if current == 'Death': return
	if name == 'Death': return animation_player.play(name)
	if name == 'Hurt': return animation_player.play(name)
	if current == 'Attack': return
	if current == 'Hurt': return
	
	animation_player.play(name)


func _look_at(rotation):
	if is_host:
		look_at(rotation)


func _determine_state():
	if health <= 0:
		return ENEMY_STATES.DYING
	
	if nearest_player == null:
		return ENEMY_STATES.IDLE

	var distance_to_nearest_player = global_position.distance_to(nearest_player.global_position)

	if distance_to_nearest_player < attack_radius:
		return ENEMY_STATES.CLAWING
	
	if distance_to_nearest_player < search_radius:
		return ENEMY_STATES.FOLLOWING

	if distance_to_nearest_player > search_radius:
		return ENEMY_STATES.IDLE


func set_nearest_player_or_null():
	var players = get_tree().get_nodes_in_group("Players")
	var _lowest_distance = null
	var _new_nearest_player = null
	
	for player in players:
		var distance_to_player = global_position.distance_squared_to(player.global_position)
		
		if _new_nearest_player == null || distance_to_player < _lowest_distance:
			_lowest_distance = distance_to_player
			_new_nearest_player = player
	
	nearest_player = _new_nearest_player


func follow_player():
	if nearest_player == null:
		return
	
	_look_at(nearest_player.global_position)
	_play_animation('Walk')
	_set_velocity(transform.x * speed)


func idle():
	_play_animation('Idle')
	_set_velocity(Vector2.ZERO)


func hurt(amount):
	_play_animation("Hurt")
	health -= amount


func death():
	_play_animation('Death')
	_set_velocity(Vector2.ZERO)
	dead = true


func attack():
	_look_at(nearest_player.global_position)
	_play_animation('Attack')


func _on_animation_finished(name):
	if name == 'Death':
		emit_signal('died', id)

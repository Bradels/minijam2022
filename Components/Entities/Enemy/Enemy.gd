extends KinematicBody2D


signal died(id)


enum ENEMY_STATES {IDLE,FOLLOWING,CLAWING,SHOOTING,DYING}

var id = ''
var velocity = Vector2.ZERO
var nearest_player

onready var is_host = get_tree().get_network_unique_id() in [0, 1]
onready var _animation_player = $AnimationPlayer
onready var _state = ENEMY_STATES.IDLE

export(float) var search_radius = 200
export(float) var attack_radius = 70
export(float) var enemy_speed = 45
export(int) var enemy_health = 2
export(int) var _enemy_damage = 1


func _process(_delta):
	set_nearest_player_or_null()
	
	if is_host:
		_determine_state()
		
	if _state == ENEMY_STATES.CLAWING:
		attack()

	if _state == ENEMY_STATES.FOLLOWING:
		follow_player()

	if _state == ENEMY_STATES.IDLE:
		idle()

	if _state == ENEMY_STATES.DYING:
		death()


func _physics_process(_delta):
	if is_host:
		velocity = move_and_slide(velocity)


func _set_velocity(new_velocity):
	if is_host:
		velocity = new_velocity


func _queue_animation(name):
	if _animation_player.current_animation != name:
		_animation_player.queue(name)


func _look_at(rotation):
	if is_host:
		look_at(rotation)


func _determine_state():
	if _state == ENEMY_STATES.DYING || enemy_health <= 0:
		_state = ENEMY_STATES.DYING
		return
	
	if nearest_player == null:
		return

	var distance_to_nearest_player = global_position.distance_to(nearest_player.global_position)
	
	if distance_to_nearest_player < search_radius:
		_state = ENEMY_STATES.FOLLOWING

	if distance_to_nearest_player > search_radius:
		_state = ENEMY_STATES.IDLE

	if distance_to_nearest_player < attack_radius:
		_state = ENEMY_STATES.CLAWING


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
	_set_velocity(transform.x * enemy_speed)
	_queue_animation('Walk')


func idle():
	_set_velocity(Vector2.ZERO)
	_queue_animation('Idle')


func hurt(amount):
	if _state == ENEMY_STATES.DYING:
		return

	_animation_player.play("Hurt")
	enemy_health -= amount


func death():
	_animation_player.play("Death")
	_set_velocity(Vector2.ZERO)


func attack():
	_queue_animation('Attack')


func _on_AnimationPlayer_animation_finished(name):
	if name == 'Death':
		emit_signal('died', id)

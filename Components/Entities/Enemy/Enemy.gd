extends KinematicBody2D


enum ENEMY_STATES {IDLE,FOLLOWING,CLAWING,SHOOTING,DYING}

var id = 0
var velocity = Vector2.ZERO

onready var _animation_player = $AnimationPlayer
onready var _current_state = ENEMY_STATES.IDLE

export(float) var search_radius = 200
export(float) var attack_radius = 70
export(float) var enemy_speed = 45
export(int) var enemy_health = 2
export(int) var _enemy_damage = 1


func _process(_delta):
	var nearest_player = get_nearest_player_or_null()
	#If no players are in the scene tree do nothing
	if nearest_player == null: return
	var distance_to_nearest_player = global_position.distance_to(nearest_player.global_position)
	if distance_to_nearest_player < search_radius:
		change_state(ENEMY_STATES.FOLLOWING)
	if distance_to_nearest_player > search_radius:
		change_state(ENEMY_STATES.IDLE)
	if enemy_health <= 0:
		change_state(ENEMY_STATES.DYING)
	if distance_to_nearest_player < attack_radius:
		change_state(ENEMY_STATES.CLAWING)
		
	if _current_state == ENEMY_STATES.CLAWING:
		attack()
	if _current_state == ENEMY_STATES.FOLLOWING:
		follow_player(nearest_player)
	if _current_state == ENEMY_STATES.IDLE:
		idle()
	if _current_state == ENEMY_STATES.DYING:
		death()


func _physics_process(_delta):
	velocity = move_and_slide(velocity)


func change_state(newState):
	if _current_state == ENEMY_STATES.DYING: return
	_current_state = newState


func get_nearest_player_or_null():
	var _nearest_player = null
	var _lowest_distance = null
	var _player_group = get_tree().get_nodes_in_group("Players")
	for player in _player_group:
		if _nearest_player == null:
			_nearest_player = player
			_lowest_distance = global_position.distance_squared_to(player.global_position)
		var distance_to_player = global_position.distance_squared_to(player.global_position)
		if distance_to_player < _lowest_distance:
			_nearest_player = player
			_lowest_distance = distance_to_player
	return _nearest_player


func follow_player(player):
	var walk_animation = "Walk"
	look_at(player.global_position)
	velocity = transform.x * enemy_speed
	if _animation_player.current_animation != walk_animation: _animation_player.queue(walk_animation)
	pass


func idle():
	var idle_animation = "Idle"
	velocity = Vector2.ZERO
	if _animation_player.current_animation != idle_animation: _animation_player.queue(idle_animation)


func hurt(amount):
	if _current_state == ENEMY_STATES.DYING:
		return
	enemy_health -= amount
	_animation_player.play("Hurt")


func death():
	_animation_player.play("Death")
	velocity = Vector2.ZERO


func attack():
	var attack_animation = "Attack"
	var targets = $HurtBox.get_overlapping_areas()
	if _animation_player.current_animation != attack_animation: _animation_player.queue(attack_animation)
	for target in targets:
		if target.has_method("hurt"):
			target.hurt(_enemy_damage)

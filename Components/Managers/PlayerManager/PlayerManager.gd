extends Node

onready var entity = preload("res://Components/Entities/Player/Player.tscn")
onready var level = get_tree().get_root().find_node('Level', true, false)
onready var projectile_manager = $ProjectileManager

onready var current_id = get_tree().get_network_unique_id()
onready var is_host = current_id in [0, 1]
onready var is_multiplayer = get_tree().has_network_peer()

var player_nodes = {}
var players_node


func _ready():
	print(level)
	call_deferred('_setup')


func _setup():
	players_node = Node2D.new()
	players_node.name = 'Players'
	level.add_child(players_node)
	_create_nodes()
	_connect_signals()
	_spawn_nodes()


func _create_nodes():
	if is_multiplayer:
		for id in Server.get_player_ids():
			var player = entity.instance()
			player.id = id
			player.is_active = id == current_id
			player_nodes[id] = player
	else:
		var player = entity.instance()
		player.is_active = true
		player_nodes[0] = player


func _connect_signals():
	for node in player_nodes.values():
		node.connect('player_transform', self, '_on_transform')
		node.connect('projectile_fired', projectile_manager, '_on_projectile_fired')


func _spawn_nodes():
	for id in player_nodes:
		players_node.add_child(player_nodes[id])


func _on_transform(props):
	if !is_multiplayer:
		return
		
	if is_host:
		rpc_unreliable('_remote_transform', props)
	else:
		rpc_unreliable_id(1, '_remote_transform', props)


remote func _remote_transform(props):
	if is_host:
		rpc_unreliable('_remote_transform', props)
		_apply_transform(props)

	elif get_tree().get_network_sender_id() == 1:
		_apply_transform(props)


func _apply_transform(props):
	var player = player_nodes[props.id]
	player.position = props.position
	player.rotation = props.rotation

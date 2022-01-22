extends Node

onready var projectile_manager = $ProjectileManager

onready var entity = preload("res://Components/Entities/Player/Player.tscn")
onready var level = get_parent()

onready var current_id = get_tree().get_network_unique_id()
onready var is_host = current_id in [0, 1]
onready var is_multiplayer = get_tree().has_network_peer()

var player_nodes = {}
var players_node


func _ready():
	players_node = Node2D.new()
	players_node.name = 'Players'
	call_deferred('_setup')


func _setup():
	level.add_child(players_node)
	_create_players()
	_connect_players()
	_spawn_players()


func _create_players():
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


func _connect_players():
	for node in player_nodes.values():
		node.connect('player_transform', self, '_on_player_transform')
		node.connect('projectile_fired', projectile_manager, '_on_projectile_fired')


func _spawn_players():
	for id in player_nodes:
		players_node.add_child(player_nodes[id])


func _on_player_transform(player):
	pass

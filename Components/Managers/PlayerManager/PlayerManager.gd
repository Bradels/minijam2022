extends Node

onready var entity = preload("res://Components/Entities/Player/Player.tscn")
onready var level = get_parent()

onready var is_multiplayer = get_tree().has_network_peer()
onready var current_id = get_tree().get_network_unique_id()

var player_nodes = {}
var players_node


func _ready():
	players_node = Node2D.new()
	players_node.name = 'Players'
	call_deferred('_setup')
	

func _setup():
	level.add_child(players_node)
	_spawn_players()


func _spawn_players():
	if is_multiplayer:
		for id in Server.get_player_ids():
			var player = entity.instance()
			player.id = id
			player.is_current = id == current_id
			player_nodes[id] = player
	else:
		var player = entity.instance()
		player.is_current = true
		player_nodes[0] = player

	for id in player_nodes:
		players_node.add_child(player_nodes[id])

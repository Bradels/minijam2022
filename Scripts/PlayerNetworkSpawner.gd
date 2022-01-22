extends Node2D

#var player = preload("res://Scenes/Entities/Player.tscn")
export(NodePath) onready var player1 = get_node(player1) as KinematicBody2D
export(NodePath) onready var player2 = get_node(player2) as KinematicBody2D
export(NodePath) onready var player3 = get_node(player3) as KinematicBody2D

func _ready():
	spawn_players(Server.get_player_ids())


func spawn_players(ids):
	var next_player = 1
	for id in ids:
		var new_player
		if next_player == 1:
			new_player = player1
		elif next_player == 2:
			new_player = player2
		elif next_player == 3:
			new_player = player3
		else:
			break

		next_player += 1

		new_player.name = str(id)
		var player_id = get_tree().get_network_unique_id()
		if id == player_id:
			new_player.is_active_player = true
			NetworkManager.local_player = new_player
		new_player.connect("player_updated",NetworkManager,"_on_entity_updated")
		new_player.connect("entity_spawned",NetworkManager,"_on_entity_spawned")

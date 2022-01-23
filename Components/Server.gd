extends Node


signal player_connected()
signal player_disconnected()
signal connection_successful()


var network
var hosting = false
var players = {}


func start_server(port, max_players):
	hosting = true
	network = NetworkedMultiplayerENet.new()
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	
	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")
	

func close_server():
	if hosting:
		rpc("player_disconnecting")
	else:
		rpc_id(1, "player_disconnecting")
	get_tree().set_network_peer(null)
	

func join_server(ip, port):
	hosting = false
	network = NetworkedMultiplayerENet.new()
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "_connection_failed")
	network.connect("connection_succeeded", self, "_connection_succeeded")


func get_player_ids():
	return players.keys()


func _peer_connected(player_id):
	print("Peer connected: " + str(player_id))


func _peer_disconnected(player_id):
	print("Peer disconnected: " + str(player_id))


func _connection_failed():
	print("Connection failed")


func _connection_succeeded():
	print("Connection succeeded")
	emit_signal("connection_successful")


remote func player_disconnecting():
	var id = get_tree().get_rpc_sender_id()
	
	if hosting:
		players.erase(id)
		rpc("host_update_player_data", players)
	else:
		close_server()
	
	emit_signal("player_disconnected")


func set_player_data(data):
	if hosting:
		players[1] = data
		rpc("host_update_player_data", players)
	else:
		rpc_id(1, "client_update_player_data", data)


remote func host_update_player_data(data):
	var id = get_tree().get_network_unique_id()
	if players.has(id):
		var my_data = players[id]
		players = data
		players[id] = my_data
	else:
		players = data
	
	print("emmitting signal")
	emit_signal("player_connected")


remote func client_update_player_data(data):
	var id = get_tree().get_rpc_sender_id()
	players[id] = data
	rpc("host_update_player_data", players)
	print("emmitting signal")
	emit_signal("player_connected")

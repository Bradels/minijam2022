extends Node


var player
var rpc_ready = false


func _ready():
	player = get_parent()
	if !get_tree().has_network_peer():
		player.is_active_player = true


func _process(_delta):
	if rpc_ready != get_tree().has_network_peer():
		rpc_ready = get_tree().has_network_peer()


func _on_Player_moved(position, rotation):
	if rpc_ready:
		rpc_unreliable("poopdate", position, rotation)


puppet func poopdate(position, rotation):
	shitdate(position, rotation)
	if player.is_host and !player.is_current:
		rpc_unreliable("shitdate", position, rotation)


puppet func shitdate(position, rotation):
	player.position = position
	player.rotation = rotation

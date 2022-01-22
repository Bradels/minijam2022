extends Node

signal entity_moved

var is_host

func _ready():
	connect("entity_moved", self, "_on_entity_moved")
	

func _on_entity_moved(entity):
	pass
	#if is_host:
	#	rpc_unreliable("move_player", position, rotation)
	#else:
	#	rpc_unreliable_id(1, "move_player", position, rotation)

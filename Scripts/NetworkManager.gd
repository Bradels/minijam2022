extends Node

signal entity_moved

var is_host

func _ready():
	is_host = (get_tree().get_network_unique_id() == 1)
	connect("entity_moved", self, "_on_entity_moved")
	

func _on_entity_updated(entity):
	if is_host:
		entity.rpc_unreliable("network_entity_moved", entity.position, entity.rotation)
	else:
		entity.rpc_unreliable_id(1, "network_entity_moved", entity.position, entity.rotation)

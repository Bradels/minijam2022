extends Node

onready var rpc_ready = get_tree().has_network_peer()


func _ready():
	pass


func _process(_delta):
	pass

func _on_Player_entity_updated(props):
	if rpc_ready:
		rpc_unreliable("entity_updated",props)
	pass # Replace with function body.

remote func entity_updated(props):
	var object = get_parent()
	for prop in props:
		object[prop] = props[prop]

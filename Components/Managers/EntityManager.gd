extends Node


onready var current_id = get_tree().get_network_unique_id()
onready var is_host = current_id in [0, 1]
onready var is_multiplayer = get_tree().has_network_peer()
onready var level = get_tree().get_root().find_node('Level', true, false)

var container_name = 'Entities'
var container
var nodes = {}


func _ready():
	call_deferred('_setup')


func _setup():
	container = Node2D.new()
	container.name = container_name
	level.add_child(container)

func _append_node(node):
	nodes[node.id] = node


func _erase_node(node):
	_erase_node_by_id(node.id)


func _erase_node_by_id(id):
	nodes.erase(id)


func _destroy_node(node):
	_destroy_node_by_id(node.id)


remote func _destroy_node_by_id(id):
	if nodes.has(id):
		nodes[id].queue_free()
		_erase_node_by_id(id)


func _random_node():
	return nodes.values()[randi() % nodes.size() - 1]


func _spawn_node(node):
	_append_node(node)
	container.add_child(node)
	_connect_signal(node)

func _connect_signal(node):
	node.connect('entity_transform', self, '_on_transform')
	node.connect('entity_prop_updated', self, '_on_entity_prop_updated')

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

	elif get_tree().get_rpc_sender_id() == 1:
		_apply_transform(props)

func _apply_transform(props):
	if nodes.has(props.id) && props.id != current_id:
		var player = nodes[props.id]
		player.position = props.position
		player.rotation = props.rotation

func _on_entity_prop_updated(id,prop,value):
	if !is_multiplayer:
		return

	if is_host:
		rpc("_remote_update_prop",id,prop,value)
	else:
		rpc_id(1,"_remote_update_prop",id,prop,value)

func _remote_update_prop(id,prop,value):
	if is_host:
		rpc("_remote_update_prop",id,prop,value)
		_apply_entity_prop(id,prop,value)
		
	elif get_tree().get_rpc_sender_id() == 1:
		_apply_entity_prop(id,prop,value)

func _apply_entity_prop(id,prop,value):
	if nodes.has(id) && nodes[id].has(prop):
		if is_host:
			nodes[id]._apply_remote_prop(prop,value)

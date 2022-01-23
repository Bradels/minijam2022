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

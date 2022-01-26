class_name NetWorkedManager

onready var _container = Node2D.new()
var _level
var nodes = {}

func _init(container_name: String,level: Node2D):
	_level = level
	_container.name = container_name

func _add_node(id,props):
	nodes[id] = props

func _remove_node(id):
	nodes.erase(id)

func _update_node(id,prop,value):
	if nodes.has(id):
		nodes[id][prop] = value
	pass

func _read_node():
	pass

puppet func remote_add_node(id,props):
	_add_node(id,props)
	pass

puppet func remote_remove_node(id):
	_remove_node(id)
	pass

puppet func remote_update_node(id,prop,value):
	_update_node(id,prop,value)
	pass

puppet func remote_read_node(id,prop,value):
	remote_read_node(id,prop,value)
	pass

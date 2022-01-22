extends Node

onready var rpc_ready = get_tree().has_network_peer()
var is_host
onready var object = get_parent()

func _ready():
	var id = get_tree().get_network_unique_id()
	is_host = (id == 1 || id == 0)
	object.connect("entity_updated",self,"_on_entity_updated")
	object.connect("entity_creates_entity",self,"_on_entity_spawns")
	


func _process(_delta):
	pass

func _on_entity_updated(props):
	if rpc_ready:
		rpc_unreliable("entity_updated",props)
	pass # Replace with function body.

remote func entity_updated(props):
	for prop in props:
		object[prop] = props[prop]

func _on_entity_spawns(props):
	if is_host:
		rpc_unreliable("spawn_entity",props)
	else:
		print("client pew")
		rpc_unreliable_id(1,"spawn_entity",props)

remote func spawn_entity(entity):
		var position = entity.position
		var rotation = entity.rotation
		var velocity = entity.velocity
		var scene_path = entity.scene_path
		var scene = load(scene_path)
		var instance = scene.instance()
		instance.position = position
		instance.rotation = rotation
		instance.velocity = velocity
		get_tree().root.add_child(instance)

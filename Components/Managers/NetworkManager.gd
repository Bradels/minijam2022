extends Node


var is_host
var local_player


func _ready():
	var id = get_tree().get_network_unique_id()
	is_host = (id == 1 || id == 0)
	var _result = connect("entity_moved", self, "_on_entity_moved")


func _on_entity_updated(_entity, props):
	if is_host:
		rpc_unreliable("network_entity_updated",props)
	else:
		rpc_unreliable_id(1,"network_entity_updated",props)


func _on_entity_spawned(_entity_owner, props):
	if is_host:
		rpc_unreliable("spawn_entity",props)
	else:
		rpc_unreliable_id(1,"spawn_entity",props)


remote func spawn_entity(entity):
	if get_tree().get_rpc_sender_id() != 1:
		rpc_unreliable("spawn_entity", entity)
		
	if get_tree().get_rpc_sender_id() == 1:
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
		

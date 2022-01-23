extends '../EntityManager.gd'


onready var entity = preload("res://Components/Entities/Enemy/Enemy.tscn")
onready var player_manager = level.find_node('PlayerManager')

export var max_enemies : int = 8
export var spawn_distance : int = 128
export var spawn_interval : float = 1
var spawn_delta : float = 0

func _setup():
	container_name = 'Enemies'
	._setup()


func _process(delta):
	if !is_host:
		return
	
	_maybe_spawn_enemy(delta)
	
	if is_multiplayer:
		for node in nodes.values():
			var ref = weakref(node)
			if ref.get_ref():
				rpc_unreliable('_remote_transform', node.id, node.position, node.rotation)


func _maybe_spawn_enemy(delta):
	spawn_delta += delta
	
	if (spawn_delta > spawn_interval && nodes.size() < max_enemies):
		spawn_delta = 0
		
		var enemy = _spawn_enemy(_get_spawn_position())
	
		if is_multiplayer:
			rpc('_remote_spawn', enemy.id, enemy.position)


func _spawn_enemy(position, id = ''):
	var enemy = entity.instance()
	
	enemy.id = id if !id.empty() else str(enemy.get_instance_id())
	enemy.position = position
	enemy.connect("died", self, '_on_died', [], 4)
	_spawn_node(enemy)
	
	return enemy


func _get_spawn_position():
	var angle = deg2rad(randi() % 360)
	var player = player_manager._random_node()
	return player.global_position + Vector2(sin(angle),cos(angle)) * spawn_distance


func _on_died(id):
	if is_host && is_multiplayer:
		_erase_node_by_id(id)
		rpc("_destroy_node_by_id", id)


remote func _remote_spawn(id, position):
	_spawn_enemy(position, id)


remote func _remote_transform(id, position, rotation):
	if nodes.has(id):
		nodes[id].position = position
		nodes[id].rotation = rotation

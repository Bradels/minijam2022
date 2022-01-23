extends '../EntityManager.gd'


onready var entity = preload("res://Components/Entities/Player/Player.tscn")
onready var projectile_manager = level.find_node('ProjectileManager')


func _setup():
	container_name = 'Players'
	._setup()
	_create_nodes()
	_connect_signals()
	
	for id in nodes:
		_spawn_node(nodes[id])


func _create_nodes():
	if is_multiplayer:
		for id in Server.get_player_ids():
			var player = entity.instance()
			player.id = id
			player.is_active = id == current_id
			nodes[id] = player
	else:
		var player = entity.instance()
		player.is_active = true
		nodes[0] = player


func _connect_signals():
	for node in nodes.values():
		node.connect('player_transform', self, '_on_transform')
		node.connect('projectile_fired', projectile_manager, '_on_projectile_fired')


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

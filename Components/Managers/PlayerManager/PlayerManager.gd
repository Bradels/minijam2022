extends '../EntityManager.gd'


onready var entity = preload("res://Components/Entities/Player/Player.tscn")
onready var projectile_manager = level.find_node('ProjectileManager')


func _setup():
	container_name = 'Players'
	._setup()
	_create_nodes()
	
	for id in nodes:
		_spawn_node(nodes[id])
		_connect_signal(nodes[id])


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


func _connect_signal(node):
	node.connect('projectile_fired', projectile_manager, '_on_projectile_fired')
	._connect_signal(node)

func _apply_transform(props):
	if nodes.has(props.id) && props.id != current_id:
		var player = nodes[props.id]
		player.position = props.position
		player.rotation = props.rotation

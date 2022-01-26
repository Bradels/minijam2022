extends '../EntityManager.gd'


onready var entity = preload("res://Components/Entities/Player/Player.tscn")
onready var projectile_manager = level.find_node('ProjectileManager')
onready var floor_manager = level.find_node('FloorManager')


func _setup():
	container_name = 'Players'
	._setup()
	floor_manager.connect("level_loaded",self,"_on_level_loaded")

func _on_transform(props):
	var current_room = floor_manager._position_to_room(props.position)
	if current_room != null && nodes[props.id].is_active:
		nodes[props.id]._update_entity_prop("current_room",current_room.number)
	._on_transform(props)

func _on_level_loaded():
	_create_nodes()

func _create_nodes():
	if is_multiplayer:
		for id in Server.get_player_ids():
			var player = entity.instance()
			player.id = id
			player.is_active = id == current_id
			nodes[id] = player
			#player.global_position = floor_manager.get_free_position_in_room(0)
	else:
		var player = entity.instance()
		player.global_position = floor_manager.get_free_position_in_room(0)
		player.is_active = true
		nodes[0] = player
	for id in nodes:
		_spawn_node(nodes[id])
		_connect_signal(nodes[id])


func _connect_signal(node):
	node.connect('projectile_fired', projectile_manager, '_on_projectile_fired')
	._connect_signal(node)

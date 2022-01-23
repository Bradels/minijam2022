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
	spawn_delta += delta
	
	if (spawn_delta > spawn_interval && nodes.size() < max_enemies):
		spawn_delta = 0
		_spawn_enemy()


func _spawn_enemy():
	var position = _get_spawn_position()
	var enemy = entity.instance()
	
	enemy.id = enemy.get_instance_id()
	enemy.position = position
	enemy.connect("tree_exited", self, '_on_tree_exited', [enemy.id], 4)
	
	._spawn_node(enemy)


func _get_spawn_position():
	var angle = deg2rad(randi() % 360)
	var player = player_manager._random_node()
	return player.global_position + Vector2(sin(angle),cos(angle)) * spawn_distance


func _on_tree_exited(id):
	_erase_node_by_id(id)

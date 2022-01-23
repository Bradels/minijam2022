extends '../EntityManager.gd'


var PROJECTILES = {
	'PAWN_PRIMARY': preload("res://Components/Entities/Projectiles/Bullet.tscn"),
	'SHIP_PRIMARY': preload("res://Components/Entities/Projectiles/Phaser.tscn"),
	'SHIP_SECONDARY': preload("res://Components/Entities/Projectiles/Rail.tscn"),
}


func _setup():
	container_name = 'Projectiles'
	._setup()


func _on_projectile_fired(props) -> void:
	var type = props["type"]
	var position = props["position"]
	var rotation = props["rotation"]
	var velocity = props["velocity"]
	var owner_id = props["owner_id"]
	
	var projectile = _create_node(type, position, rotation, velocity, str(owner_id))
	_spawn_node(projectile)
	
	if is_multiplayer:
		rpc(
			"_remote_spawn_projectile",
			type,
			position,
			rotation,
			velocity,
			str(owner_id),
			projectile.id
		)


func _create_node(
	type:String = '',
	position:Vector2 = Vector2.ZERO,
	rotation:float = 0,
	velocity:Vector2 = Vector2.ZERO,
	owner_id:String = '',
	id:String = ''
) -> String:
	var scene = PROJECTILES[type]
	var instance = scene.instance()
	
	instance.id = id if !id.empty() else _create_id(instance)
	instance.owner_id = owner_id
	instance.position = position
	instance.rotation = rotation
	instance.velocity = velocity
	instance.connect("tree_exited", self, "_on_projectile_destroyed", [instance.id], 4)
	
	return instance


func _create_id(node):
	return str(node.owner_id) + '_' + str(node.get_instance_id())


func _on_projectile_destroyed(id) -> void:
	_erase_node_by_id(id)


remote func _remote_spawn_projectile(type, position, rotation, velocity, owner_id, id) -> void:
	var projectile = _create_node(type, position, rotation, velocity, owner_id, id)
	_spawn_node(projectile)

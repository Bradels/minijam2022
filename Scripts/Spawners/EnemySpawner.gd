extends "Spawner.gd"

var spawned = 0

func _ready():
	pass

func _spawn_at_location(position:Vector2) -> void:
	pass

func _spawn_random() -> void:
	if spawned <= data.spawn_max:
		var random_position = location.get_random_position()
		var object = data.spawn_object.instance()
		location.add_child(object)
		object.global_position = random_position
		spawned += 1
	pass

func _on_SpawnInterval_timeout():
	_spawn_random()

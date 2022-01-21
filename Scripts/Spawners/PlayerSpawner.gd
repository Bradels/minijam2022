extends "res://Scripts/Spawners/Spawner.gd"

func _ready():
	var random_position = location.get_random_position()
	_spawn_at_location(random_position)

func _spawn_at_location(position : Vector2) -> void:
	var object = data.spawn_object.instance()
	location.add_child(object)
	object.global_position = random_position

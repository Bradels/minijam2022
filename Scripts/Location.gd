extends Node2D

class_name GameLocation

export(Resource) var data
export(PackedScene) var test_spawner

func _ready():
	#data = LocationData.new()
	data.add_spawnable(test_spawner)
	for spawner in data.spawners:
		var n_spawner = spawner.instance()
		n_spawner.set_location(self)
		add_child(n_spawner)

func get_random_position() -> Vector2:
	var height = randi() % data.get_height()
	var length = randi() % data.get_length()
	return Vector2(length,height)

extends "res://Scripts/Spawners/Spawner.gd"


onready var spawn_object = preload("res://Scenes/Entities/Enemy.tscn")
export var spawn_max : int = 50
var spawned = 0


func _spawn_random() -> void:
	if spawned <= spawn_max:
		var random_position = location.get_random_position()
		var object = spawn_object.instance()
		location.add_child(object)
		object.global_position = random_position
		spawned += 1
	pass


func _on_SpawnInterval_timeout():
	_spawn_random()

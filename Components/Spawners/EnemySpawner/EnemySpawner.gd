extends "res://Scripts/Spawners/Spawner.gd"

onready var location : GameLocation = get_parent()
onready var spawn_object = preload("res://Components/Entities/Enemy/Enemy.tscn")
export var spawn_max : int = 50
var spawned  : int = 0


func set_location(new_location : GameLocation) -> void:
	location = new_location


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

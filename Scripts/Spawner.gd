extends Node2D

class_name Spawner

export(Resource) var data
var location:GameLocation

func _spawn_at_location(position:Vector2) -> void:
	pass

func _spawn_random() -> void:
	pass

func set_location(new_location:GameLocation) -> void:
	location = new_location

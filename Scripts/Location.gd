extends Node2D

class_name GameLocation

export(int) var location_height:int = 1000
export(int) var location_length:int = 1000

func _ready():
	pass

func get_random_position() -> Vector2:
	var height = randi() % location_height
	var length = randi() % location_length
	return Vector2(length,height)


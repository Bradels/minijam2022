extends Resource

class_name LocationData

export var spawners:Array = []
export(int) var location_height:int = 1000
export(int) var location_length:int = 1000

func add_spawnable(spawner:PackedScene) -> void:
	spawners.append(spawner)

func get_height() -> int:
	return location_height

func get_length() -> int:
	return location_length

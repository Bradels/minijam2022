extends Node

onready var generator = get_tree().get_root().find_node('FloorGenerator', true, false)

func _position_to_room(position):
	var rooms = generator.floor_structure
	for room in rooms:
		if room.is_position_in_room(position):
			return room
	return null

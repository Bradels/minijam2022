class_name FloorGenerator

class RoomInformation:
	var type = ""
	var size = Vector2(32*32,32*32)
	var number
	var connections = {
		Cardinals.vector_from_direction("N"): null,
		Cardinals.vector_from_direction("S"): null,
		Cardinals.vector_from_direction("E") : null,
		Cardinals.vector_from_direction("W") : null
	}
	var position:Vector2
	var world_position: Vector2
	
	func get_rect2():
		return Rect2(world_position,size)
	
	var instance
	
	func is_position_in_room(test_position):
		var area = get_rect2()
		if area.has_point(test_position):
			return true
		else:
			return false
		

export var random_seed:int

var _types = []

var floor_structure = []

func register_type(name):
	_types.append(name)

func generate_floor(length:int,gen_seed):
	seed(gen_seed)
	var initial_room = RoomInformation.new()
	initial_room.position = Vector2(0,0)
	initial_room.type = 'start'
	floor_structure.push_front(initial_room)
	var room_number = 0
	initial_room.number = room_number
	for current_floor in range(length):
		var room_at_front = floor_structure.front()
		if !is_position_full(room_at_front.position):
			room_number += 1
			var random_position = get_random_position(room_at_front.position)
			var new_room = RoomInformation.new()
			var room_type = _types[randi() % _types.size()]
			if current_floor == length:
				room_type = 'end'
			room_at_front.connections[random_position] = new_room
			new_room.position = room_at_front.position + random_position
			new_room.connections[Cardinals.inverse_vector(random_position)] = room_at_front
			new_room.world_position = Vector2(new_room.position.x * new_room.size.x,new_room.position.y * new_room.size.y)
			new_room.number = room_number
			new_room.type = room_type
			floor_structure.push_front(new_room)
	return floor_structure

func get_random_position(position:Vector2):
	var free_places = get_free_positions(position)
	var random = randi()%free_places.size()
	var random_position = free_places[random]
	return random_position

func _position_from_direction(position,direction):
	return position + direction

func _direction_from_vector(position,direction):
	return position - direction

func get_free_positions(position:Vector2) ->Array:
	var directions = Cardinals.get_basic_vectors()
	var free_directions = []
	for direction in directions:
		if is_position_free(position+direction):
			free_directions.append(direction)
	return free_directions

func is_position_free(position:Vector2) -> bool:
	for room in floor_structure:
		if room.position == position:
			return false
	return true

func is_position_full(position:Vector2) -> bool:
	for direction in ["N","E","S","W"]:
		if is_position_free(position + Cardinals.vector_from_direction(direction)):
			return false
	return true

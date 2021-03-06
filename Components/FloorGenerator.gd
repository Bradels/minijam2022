extends Node

onready var current_id = get_tree().get_network_unique_id()
onready var is_host = current_id in [0, 1]
onready var is_multiplayer = get_tree().has_network_peer()
export(String) var level_seed = "test"
var gen_seed
var room_types = [
	preload("res://Levels/Rooms/Room1.tscn"),
	preload("res://Levels/Rooms/Room2.tscn")
]

class RoomInformation:
	var type
	var connections = {
		"north": null,
		"south": null,
		"east" : null,
		"west" : null
	}
	var position:Vector2

var floor_structure = []
export var random_seed:int
onready var level = get_tree().get_root().find_node('Level', true, false)
var directionVectors = {
		"north": Vector2(0,-1),
		"south": Vector2(0,1),
		"east" : Vector2(1,0),
		"west" : Vector2(-1,0)
	}

var inverse_direction = {
		"north": "south",
		"south": "north",
		"east" : "west",
		"west" : "east"
	}

func _ready():
	if is_host:
		_generate_level()
	elif is_multiplayer:
		rpc('_client_request_seed')


remote func _client_receive_seed(gen_seed):
	self.gen_seed = gen_seed
	_generate_level()

remote func _client_request_seed():
	if is_host:
		rpc("_client_receive_seed",gen_seed)
		
func _generate_level():
	generate_floor(10)
	add_floors_to_scene()

func add_floors_to_scene():
	for room in floor_structure:
		var rand_index:int = randi() % room_types.size()
		var room_instance = room_types[rand_index].instance()
		level.call_deferred('add_child',room_instance)
		room_instance.global_position = room.position * room_instance.room_height * 32
		for connection in room.connections:
			if room.connections[connection] != null:
				room_instance.call_deferred("add_door",connection)


func generate_floor(length:int):
	var initial_room = RoomInformation.new()
	initial_room.position = Vector2(-0.3,-0.3)
	floor_structure.push_front(initial_room)
	for current_floor in range(length):
		var room_at_front = floor_structure.front()
		if !is_position_full(room_at_front.position):
			var random_direction = get_random_direction(room_at_front.position)
			var new_room = RoomInformation.new()
			room_at_front.connections[random_direction] = new_room
			new_room.position = room_at_front.position + directionVectors[random_direction]
			new_room.connections[inverse_direction[random_direction]] = room_at_front
			floor_structure.push_front(new_room)
		pass
	pass

func get_random_direction(position:Vector2,nbias = 50, sbias = 50, ebias = 80, wbias = 80):
	var random_direction = get_free_direction(position)
	var outcomes = {
		"north": randi()%nbias,
		"south": randi()%sbias,
		"east" : randi()%ebias,
		"west" : randi()%wbias
		}
	for direction in outcomes:
		if (outcomes[direction] > outcomes[random_direction]) && is_position_free(position+directionVectors[direction]): random_direction = direction
	return random_direction

func get_free_direction(position:Vector2):
	for direction in directionVectors:
		if is_position_free(position+directionVectors[direction]):
			return direction

func is_position_free(position:Vector2) -> bool:
	for room in floor_structure:
		if room.position == position:
			return false
	return true

func is_position_full(position:Vector2) -> bool:
	for direction in directionVectors:
		if is_position_free(position + directionVectors[direction]):
			return false
	return true

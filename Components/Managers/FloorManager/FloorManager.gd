extends Node

signal level_loaded()
var rooms_in_floor = 10
export(String) var level_seed = "fgfgfg"
onready var gen_seed = level_seed.hash()
onready var current_id = get_tree().get_network_unique_id()
onready var is_host = current_id in [0, 1]
onready var is_multiplayer = get_tree().has_network_peer()
onready var generator = FloorGenerator.new()
onready var level = get_tree().get_root().find_node('Level', true, false)
var container_name = 'Floors'
var container
var floors = {}
var rooms = []
onready var debug = $FloorDebugger

var room_types = {
	"end" : preload("res://Levels/Rooms/RoomEnd.tscn"),
	"start" : preload("res://Levels/Rooms/RoomStart.tscn"),
	"1" : preload("res://Levels/Rooms/Room1.tscn"),
	"2" : preload("res://Levels/Rooms/Room2.tscn"),
	"3" : preload("res://Levels/Rooms/Room3.tscn"),
}

func _ready():
	call_deferred('_setup')
	
func _setup():
	container = Node2D.new()
	container.name = container_name
	level.add_child(container)
	for type in room_types:
		generator.register_type(type)
	if is_host:
		rooms = generator.generate_floor(rooms_in_floor,gen_seed)
		#debug.update()
		_generate_level()
	else:
		rpc_id(1,"_client_request_seed")
	

func _generate_level():
	add_floor_to_scene(rooms,0)

func add_floor_to_scene(rooms,floor_number):
	var floor_container = Node2D.new()
	floor_container.name = "Floor" + str(floor_number)
	container.add_child(floor_container)
	for room in rooms:
		var room_instance = room_types[room.type].instance()
		floor_container.add_child(room_instance)
		room_instance.global_position = room.world_position
		room.instance = room_instance
		for connection in room.connections:
			if room.connections[connection] != null:
				room_instance.add_door(connection)
	emit_signal("level_loaded")

func _position_to_room(position):
	var rooms = generator.floor_structure
	for room in rooms:
		if room.is_position_in_room(position):
			return room
	return null

func _get_room_from_number(number):
	for room in rooms:
		if room.number == number:
			return room
	return null

func get_free_position_in_room(room_number):
	var room = _get_room_from_number(room_number)
	if room != null:
		return room.instance.get_random_free_position()
	return null


remote func _client_receive_seed(gen_seed):
	self.gen_seed = gen_seed
	_generate_level()

remote func _client_request_seed():
	rpc_id(get_tree().get_rpc_sender_id(),"_client_receive_seed",gen_seed)

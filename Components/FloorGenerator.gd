extends Node

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


var floor_image = preload("res://Assets/Textures/Spaceship.png")
onready var level = get_tree().get_root().find_node('Level', true, false)
var directionVectors = {
		"north": Vector2(0,-1),
		"south": Vector2(0,1),
		"east" : Vector2(1,0),
		"west" : Vector2(-1,0)
	}

func _ready():
	generate_floor(10)
	for room in floor_structure:
		var sprite = Sprite.new()
		sprite.texture = floor_image
		level.call_deferred('add_child',sprite)
		sprite.global_position = room.position * 400


func generate_floor(length:int):
	var initial_room = RoomInformation.new()
	initial_room.position = Vector2.ZERO
	floor_structure.append(initial_room)
	for current_floor in range(length):
		var room_at_front = floor_structure.front()
		if !is_position_full(room_at_front.position):
			var random_direction = get_random_direction(room_at_front.position)
			var new_room = RoomInformation.new()
			room_at_front.connections[random_direction] = new_room
			new_room.position = room_at_front.position + directionVectors[random_direction]
			floor_structure.push_front(new_room)
		pass
	pass

func get_random_direction(position:Vector2,nbias = 80, sbias = 1, ebias = 10, wbias = 10):
	randomize()
	var random_direction = get_free_direction(position)
	var outcomes = {
		"north": randi()%nbias,
		"south": randi()%sbias,
		"east" : randi()%ebias,
		"west" : randi()%wbias
		}
	for direction in outcomes:
		if (outcomes[direction] > outcomes[direction]) && is_position_free(position+directionVectors[direction]): random_direction
	print(random_direction)
	return random_direction

func get_free_direction(position:Vector2):
	for direction in directionVectors:
		if is_position_free(directionVectors[direction]):
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

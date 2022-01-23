extends Node2D

onready var walls = $Walls
export(int) var room_height = 32
export(int) var room_length = 32

export var north_door = [Vector2(15,0),Vector2(16,0),Vector2(17,0)]
export var south_door = [Vector2(15,32),Vector2(16,32),Vector2(17,32)]
export var east_door = [Vector2(32,15),Vector2(32,16),Vector2(32,17)]
export var west_door = [Vector2(0,15),Vector2(0,16),Vector2(0,17)]

var doors = {
	"north" : north_door,
	"south" : south_door,
	"east" : east_door,
	"west" : west_door
}

func add_door(direction):
	for door_pos in doors[direction]:
		walls.set_cell(door_pos.x,door_pos.y,4)

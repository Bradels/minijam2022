extends Node

var is_in_game = false
var is_paused = false

var LEVELS = {
	'MULTIPLAYER_TEST': preload('res://Levels/MultiplayerTest.tscn'),
	'SPACESHIP_TEST': preload('res://Levels/SpaceshipTest.tscn'),
	'FLOOR_TEST': preload('res://Levels/TestFloor.tscn'),
	'TILEMAP_TEST': preload('res://Levels/TestTilemap.tscn'),
}


func _reset_level():
	for child in get_children():
		remove_child(child)
		child.queue_free()


func change_level(level):
	_reset_level()
	add_child(LEVELS[level].instance())
	is_in_game = true


func exit():
	_reset_level()
	is_in_game = false

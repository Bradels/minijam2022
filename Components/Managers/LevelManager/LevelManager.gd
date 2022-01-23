extends Node


onready var Menus = get_tree().get_root().find_node('Menus', true, false)

var is_in_game = false
var is_paused = false

var LEVELS = {
	'FLOOR_GENERATOR_TEST': preload('res://Levels/FloorGeneratorTest.tscn'),
	'FLOOR_TEST': preload('res://Levels/FloorTest.tscn'),
	'MULTIPLAYER_TEST': preload('res://Levels/MultiplayerTest.tscn'),
	'SPACESHIP_TEST': preload('res://Levels/SpaceshipTest.tscn'),
	'TILEMAP_TEST': preload('res://Levels/TilemapTest.tscn'),
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
	is_paused = false
	Menus.change_menu('MAIN')


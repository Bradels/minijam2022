extends Node


onready var LevelManager = get_tree().get_root().find_node('LevelManager', true, false)

onready var background = $Background
onready var music = $Music
onready var node = $Menu
var menu

var MENUS = {
	'MAIN': preload('Menu/MainMenu/MainMenu.tscn'),
	'HOST': preload('Menu/HostMenu/HostMenu.tscn'),
	'LOBBY': preload('Menu/LobbyMenu/LobbyMenu.tscn'),
	'JOIN': preload('Menu/JoinMenu/JoinMenu.tscn'),
	'OPTIONS': preload('Menu/OptionsMenu/OptionsMenu.tscn'),
	'PAUSE': preload('Menu/PauseMenu/PauseMenu.tscn'),
}


func _ready():
	change_menu('MAIN')


func _process(_delta):
	if Input.is_action_just_pressed('ui_cancel') && !LevelManager.is_paused:
		LevelManager.is_paused = true
		change_menu('PAUSE')


func _cleanup():
	for child in node.get_children():
		child.queue_free()


func change_menu(key):
	_cleanup()
	
	menu = key
	node.add_child(MENUS[key].instance())
	
	if menu != 'PAUSE':
		background.visible = true
		music.play()


func close_menu():
	_cleanup()
	background.visible = false
	music.stop()

extends '../Menu.gd'


onready var LevelManager = get_tree().get_root().find_node('LevelManager', true, false)

onready var BackButton = $Panel/BackButton
onready var StartButton = $Panel/StartButton
onready var LevelList = $Panel/PlayerList
var selected_level


func _ready():
	_connect()
	_set_options()


func _connect():
	BackButton.connect('click', self, '_on_click_back')
	StartButton.connect('click', self, '_on_click_start')
	LevelList.connect('item_selected', self, '_on_level_selected')


func _set_options():
	for level in LevelManager.LEVELS.keys():
		LevelList.add_item(Str.snake2camel(level))


func _on_click_back():
	_change_menu('MAIN')


func _on_click_start():
	LevelManager.change_level(selected_level)
	_close_menu()


func _on_level_selected(index):
	StartButton.disabled = false
	selected_level = LevelManager.LEVELS.keys()[index]

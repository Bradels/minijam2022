extends '../Menu.gd'


onready var LevelManager = get_tree().get_root().find_node('LevelManager', true, false)

onready var LeaveButton = $Panel/LeaveButton
onready var StartButton = $Panel/StartButton
onready var PlayerList = $Panel/PlayerList


func _ready():
	StartButton.disabled = !Server.hosting
	_connect()
	_update_lobby()


func _connect():
	LeaveButton.connect('click', self, '_on_click_leave')
	StartButton.connect('click', self, '_on_click_start')
	Server.connect("player_connected", self, "_update_lobby")
	Server.connect("player_disconnected", self, "_update_lobby")


func _on_click_leave():
	Server.close_server()
	_change_menu('MAIN')


func _on_click_start():
	_start_game()
	
	if Server.active && Server.hosting:
		rpc('_start_game')

func _update_lobby():
	PlayerList.clear()
	for player in Server.players.values():
		PlayerList.add_item(player['name'])


remote func _start_game():
	LevelManager.change_level('FLOOR_GENERATOR_TEST')
	_close_menu()

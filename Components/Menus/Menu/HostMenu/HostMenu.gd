extends '../Menu.gd'


onready var back_button = $Panel/BackButton
onready var host_button = $Panel/HostButton
onready var name_input = $Panel/NameInput
onready var port_input = $Panel/PortInput
onready var max_players_input = $Panel/MaxPlayersInput

var player_name = 'HostPlayer'
var server_port = 5676
var max_players = 4


func _ready():
	_connect()
	_set_inputs()


func _connect():
	back_button.connect('click', self, '_on_click_back')
	host_button.connect('click', self, '_on_click_host')
	name_input.connect('text_changed', self, '_on_name_changed')
	port_input.connect('text_changed', self, '_on_port_changed')
	max_players_input.connect('value_changed', self, '_on_max_players_changed')


func _set_inputs():
	name_input.text = player_name
	port_input.text = str(server_port)
	max_players_input.value = max_players


func _on_click_back():
	_change_menu('MAIN')


func _on_click_host():
	Server.start_server(server_port, max_players)
	Server.set_player_data({ "name": player_name })
	_change_menu('LOBBY')


func _on_name_changed(text):
	player_name = text


func _on_port_changed(text):
	server_port = int(text)


func _on_max_players_changed(value):
	max_players = value

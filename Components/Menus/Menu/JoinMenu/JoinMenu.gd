extends '../Menu.gd'


onready var back_button = $Panel/BackButton
onready var join_button = $Panel/JoinButton
onready var name_input = $Panel/NameInput
onready var host_input = $Panel/HostInput
onready var port_input = $Panel/PortInput

var player_name = 'ClientPlayer'
var server_host = '127.0.0.1'
var server_port = 5676


func _ready():
	_connect()
	_set_inputs()


func _connect():
	back_button.connect('click', self, '_on_click_back')
	join_button.connect('click', self, '_on_click_join')
	name_input.connect('text_changed', self, '_on_name_changed')
	host_input.connect('text_changed', self, '_on_host_changed')
	port_input.connect('text_changed', self, '_on_port_changed')
	Server.connect('connection_successful', self, '_on_connected')


func _set_inputs():
	name_input.text = player_name
	host_input.text = server_host
	port_input.text = str(server_port)


func _on_click_back():
	_change_menu('MAIN')


func _on_click_join():
	Server.join_server(server_host, server_port)


func _on_name_changed(text):
	player_name = text


func _on_host_changed(text):
	server_host = text


func _on_port_changed(text):
	server_port = int(text)


func _on_connected():
	Server.set_player_data({ "name": player_name, "health": randi() % 32 })
	_change_menu('LOBBY')

extends '../Menu.gd'


onready var host_button = $HostButton
onready var join_button = $JoinButton
onready var options_button = $OptionsButton
onready var exit_button = $ExitButton


func _ready():
	_connect()
	._ready()


func _connect():
	host_button.connect('click', self, '_on_click_host')
	join_button.connect('click', self, '_on_click_join')
	options_button.connect('click', self, '_on_click_options')
	exit_button.connect('click', self, '_on_click_exit')


func _on_click_host():
	_change_menu('HOST')


func _on_click_join():
	_change_menu('JOIN')


func _on_click_options():
	_change_menu('OPTIONS')


func _on_click_exit():
	get_tree().quit()

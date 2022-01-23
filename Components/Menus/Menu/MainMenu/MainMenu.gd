extends '../Menu.gd'


onready var PlayButton = $PlayButton
onready var HostButton = $HostButton
onready var JoinButton = $JoinButton
onready var OptionsButton = $OptionsButton
onready var ExitButton = $ExitButton


func _ready():
	_connect()
	._ready()


func _connect():
	PlayButton.connect('click', self, '_on_click_play')
	HostButton.connect('click', self, '_on_click_host')
	JoinButton.connect('click', self, '_on_click_join')
	OptionsButton.connect('click', self, '_on_click_options')
	ExitButton.connect('click', self, '_on_click_exit')


func _on_click_play():
	_change_menu('LEVEL')


func _on_click_host():
	_change_menu('HOST')


func _on_click_join():
	_change_menu('JOIN')


func _on_click_options():
	_change_menu('OPTIONS')


func _on_click_exit():
	get_tree().quit()

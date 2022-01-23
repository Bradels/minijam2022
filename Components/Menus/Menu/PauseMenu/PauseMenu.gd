extends '../Menu.gd'


onready var LevelManager = get_tree().get_root().find_node('LevelManager', true, false)

onready var ResumeButton = $Panel/ResumeButton
onready var ExitMenuButton = $Panel/ExitMenuButton
onready var ExitGameButton = $Panel/ExitGameButton


func _ready():
	ResumeButton.connect('click', self, '_on_resume')
	ExitMenuButton.connect('click', self, '_on_exit_menu')
	ExitGameButton.connect('click', self, '_on_exit_game')


func _process(_delta):
	if Input.is_action_just_pressed('ui_cancel') && LevelManager.is_paused:
		_on_resume()


func _on_resume():
	_close_menu()
	LevelManager.is_paused = false


func _on_exit_menu():
	LevelManager.exit()
	Server.close_server()


func _on_exit_game():
	get_tree().quit()

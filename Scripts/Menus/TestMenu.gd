extends Node2D

onready var _enemy = $Enemy
onready var _player = $Player
var current = 'Player'


func _ready():
	if (current == 'Player'):
		_player.is_current = true


func _on_Button_button_up():
	if (current == 'Player'):
		current = 'Spaceship'
	else:
		current = 'Player'

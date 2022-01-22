extends Control

onready var position_label = $Position
onready var speed_label = $Speed


func position(position):
	position_label.text = 'Position: ' + str(int(position.x)) + ', ' + str(int(position.y))


func speed(speed):
	speed_label.text = 'Speed: ' + str(int(speed))

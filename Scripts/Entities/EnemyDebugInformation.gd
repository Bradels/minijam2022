tool
extends Node2D

#Editor Hints
export(Color) var search_radius_color
export(Color) var attack_radius_color
export(bool) var debug_in_game = false
onready var _enemy = get_parent()

func _draw():
	draw_circle(_enemy.position,_enemy.search_radius,search_radius_color)
	draw_circle(_enemy.position,_enemy.attack_radius,attack_radius_color)
	pass

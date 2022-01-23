extends Node


onready var menus = get_tree().get_root().find_node('Menus', true, false)


func _change_menu(menu):
	menus.change_menu(menu)


func _close_menu():
	menus.close_menu()

extends Node


onready var scene = $Scene


func _reset_scene():
	for child in scene.get_children():
		scene.remove_child(child)
		child.queue_free()


func change_scene(instance):
	_reset_scene()
	scene.add_child(instance)


extends Node


func reset():
	for child in get_children():
		remove_child(child)
		child.queue_free()


func load_scene(scene):
	add_child(scene)

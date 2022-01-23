extends Node


onready var scene = $Scene
export(Texture) var cursor_image 

func _ready():
	Input.set_custom_mouse_cursor(cursor_image,
		Input.CURSOR_ARROW)

func _reset_scene():
	for child in scene.get_children():
		scene.remove_child(child)
		child.queue_free()


func change_scene(instance):
	_reset_scene()
	scene.add_child(instance)

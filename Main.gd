extends Node


onready var cursor : Texture = preload('res://Assets/Textures/Cursor.png')
onready var options = SaveManager.load_options()


func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(options['volume'] * 0.01))
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW)

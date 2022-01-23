extends Node


onready var cursor : Texture = preload('res://Assets/Textures/Cursor.png')
onready var options = SaveManager.load_options()


func _ready():
	var volume = options['volume'] if options.has('volume') else 40
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(volume * 0.01))
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW)

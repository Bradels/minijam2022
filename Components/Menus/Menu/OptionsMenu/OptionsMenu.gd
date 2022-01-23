extends '../Menu.gd'


onready var back_button = $Panel/BackButton
onready var apply_button = $Panel/ApplyButton
onready var volume_control = $Panel/MasterVolume
onready var options = SaveManager.load_options()


func _ready():
	_connect()
	_set_options()


func _connect():
	back_button.connect('click', self, '_on_click_back')
	apply_button.connect('click', self, '_on_click_apply')
	volume_control.connect('value_changed', self, '_on_volume_changed')


func _load_options():
	options = SaveManager.load_options()


func _save_options():
	SaveManager.save_options(options)


func _set_options():
	if options.has('volume'):
		volume_control.value = options['volume']


func _set_volume(volume):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(volume * 0.01))
	options['volume'] = volume


func _on_click_back():
	_load_options()
	_set_options()
	_change_menu('MAIN')


func _on_click_apply():
	_save_options()
	_change_menu('MAIN')


func _on_volume_changed(volume):
	_set_volume(volume)

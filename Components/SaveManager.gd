extends Node

var options_save_file = "options.save"

func _ready():
	pass
	
func save_options(options):
	var options_save = File.new()
	options_save.open("user://" + options_save_file, File.WRITE)
	options_save.store_line(to_json(options))
	

func load_options():
	var options_save = File.new()
	options_save.open("user://" + options_save_file, File.READ)
	var line = options_save.get_line()
	if line != "":
		return parse_json(line)
	else:
		return {}

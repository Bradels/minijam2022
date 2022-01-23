extends Node


var options_file = "options.save"


func save_options(options):
	var file = File.new()
	file.open("user://" + options_file, File.WRITE)
	file.store_line(to_json(options))
	file.close()


func load_options():
	var file = File.new()
	file.open("user://" + options_file, File.READ)
	
	var line = file.get_line()
	var options = parse_json(line) if line != '' else {}
	file.close()
	
	return options

extends Node2D


var location : GameLocation


func _ready():
	location = get_parent()


func set_location(new_location : GameLocation) -> void:
	location = new_location

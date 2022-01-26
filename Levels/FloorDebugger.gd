extends Node2D


func _draw():
	for room in get_parent().rooms:
		var randColor = Color(randf(),randf(),randf(),0.4)
		draw_rect(room.get_rect2(),randColor,true)

func _draw_debug(delta):
	update()

extends Camera2D

var zoom_default : float = 1
var zoom_max : float = 0.75
var zoom_min : float = 2

onready var tween = $Tween

func _ready():
	_set_zoom(zoom_default)


func _set_zoom(level):
	var clamped = clamp(level, zoom_max, zoom_min)
	
	tween.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(clamped, clamped),
		0.1,
		tween.TRANS_SINE,
		tween.EASE_OUT
	)
	
	tween.start()



func zoom_in():
	_set_zoom(zoom.x - 0.25)


func zoom_out():
	_set_zoom(zoom.x + 0.25)

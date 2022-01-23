extends Button


signal hover()
signal click()


onready var hover_audio = $ButtonHover
onready var press_audio = $ButtonHover


func _ready():
	connect('mouse_entered', self, '_on_hover')
	connect('pressed', self, '_on_click')


func _on_hover():
	if !disabled:
		hover_audio.play(0.0)
		emit_signal('hover')


func _on_click():
	press_audio.play(0.0)
	emit_signal('click')

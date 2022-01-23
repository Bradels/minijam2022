extends Node

onready var audio = get_node("/root/Main/Audio")

func stop_music():
	for music in audio.get_children():
		music.stop()

func play_music(music_node):
	stop_music()
	audio.get_node(music_node).play(0.0)

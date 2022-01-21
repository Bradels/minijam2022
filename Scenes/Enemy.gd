extends KinematicBody2D

func _physics_process(_delta):
	var player_pos = get_parent().get_node("Player").global_position
	look_at(player_pos)

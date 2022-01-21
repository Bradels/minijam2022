extends KinematicBody2D

onready var _animation_player = $AnimationPlayer

func _physics_process(_delta):
	var player = get_parent().get_node_or_null("Player")
	if (player):
		look_at(player.global_position)

	var spaceship = get_parent().get_node_or_null("Spaceship")
	if (spaceship):
		look_at(spaceship.global_position)

extends Node2D

var primary_projectile : PackedScene = preload("res://Components/Entities/Projectiles/Phaser.tscn")
var primary_left
var primary_right
var primary_elapsed_left : float = 0
var primary_elapsed_right : float = 0
var primary_previous = 'right'
var primary_rate : float = 2
var primary_speed : int = 768
onready var primary_delta : float = 1 / primary_rate

var secondary_projectile : PackedScene = preload("res://Components/Entities/Projectiles/Rail.tscn")
var secondary_left
var secondary_right
var secondary_elapsed_left : float = 0
var secondary_elapsed_right : float = 0
var secondary_previous = 'right'
var secondary_rate : float = 0.5
var secondary_speed : int = 1536
onready var secondary_delta : float = 1 / secondary_rate
onready var secondary_sound_byte = $Pew


func _ready():
	primary_left = $PulseLaserLeft
	primary_right = $PulseLaserRight
	secondary_left = $RailgunLeft
	secondary_right = $RailgunRight


func elapse_time(delta):
	primary_elapsed_left += delta
	primary_elapsed_right += delta
	secondary_elapsed_left += delta
	secondary_elapsed_right += delta


func fire_primary():
	var primary_next = opposite_side(primary_previous)
	
	if (get('primary_elapsed_' + primary_next) >= primary_delta):
		return fire_primary_side(primary_next)


func fire_primary_side(side):
	set('primary_elapsed_' + side, 0)
	set('primary_elapsed_' + opposite_side(side), primary_delta / 4)
	primary_previous = side
	
	var weapon = get('primary_' + side)
	fire_projectile(primary_projectile, weapon.global_position, primary_speed)


func fire_secondary():
	var secondary_next = opposite_side(secondary_previous)
	
	if (get('secondary_elapsed_' + secondary_next) >= secondary_delta):
		return fire_secondary_side(secondary_next)


func fire_secondary_side(side):
	set('secondary_elapsed_' + side, 0)
	set('secondary_elapsed_' + opposite_side(side), secondary_delta / 4)
	secondary_previous = side
	
	var weapon = get('secondary_' + side)
	fire_projectile(secondary_projectile, weapon.global_position, secondary_speed)


func fire_projectile(projectile, source, speed):
	var instance = projectile.instance()
	var rotation = get_parent().rotation
	instance.position = source
	instance.rotation = rotation
	instance.velocity = Vector2(speed, 0).rotated(rotation)
	get_tree().get_root().call_deferred('add_child', instance)


func opposite_side(side):
	return 'right' if side == 'left' else 'left'


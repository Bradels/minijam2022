extends Node

class_name ProjectileManager


enum PROJECTILE_TYPE {SHIP_PRIMARY,SHIP_SECONDARY,PAWN_PRIMARY}

onready var is_multiplayer = get_tree().has_network_peer()
var ship_primary_projectile = preload("res://Components/Entities/Projectiles/Phaser.tscn")
var ship_secondary_projectile = preload("res://Components/Entities/Projectiles/Phaser.tscn")
var pawn_primary_projectile = preload("res://Components/Entities/Projectiles/Bullet.tscn")

var projectiles = {}

var projectile_type_map = {
	"pawn_bullet" : PROJECTILE_TYPE.PAWN_PRIMARY,
	"ship_prime" : PROJECTILE_TYPE.SHIP_PRIMARY,
	"ship_secondary": PROJECTILE_TYPE.SHIP_SECONDARY
}

func _on_projectile_fired(type,props) -> void:
	
	spawn_projectile(
		projectile_type_map[props["type"]],
		props["posistion"],
		props["rotation"],
		props["velocity"],
		props["id"],
		props["ownerid"])
		
	if is_multiplayer: rpc("rpc_spawn_project",type,props)

remote func spawn_projectile(
	type:int,
	posistion:Vector2,
	rotation:float,
	velocity:Vector2 = Vector2.ZERO,
	id:String = "",
	ownerid:String = "") -> void:
	var scene = _look_up_projectile(type)
	var instance = scene.instance()
	add_child(instance)
	instance.position = posistion

func _look_up_projectile(projectile_type:int) -> PackedScene:
	if projectile_type == PROJECTILE_TYPE.SHIP_PRIMARY:
		return ship_primary_projectile
	if projectile_type == PROJECTILE_TYPE.SHIP_SECONDARY:
		return ship_secondary_projectile
	if projectile_type == PROJECTILE_TYPE.PAWN_PRIMARY:
		return pawn_primary_projectile
	return null
